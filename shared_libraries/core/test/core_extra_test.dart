import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

class FakeChecker implements DataConnectionChecker {
  FakeChecker(this.value);

  final bool value;

  @override
  Future<bool> get hasConnection async => value;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCrashReporter implements CrashReporter {
  final List<Object> nonFatalErrors = [];

  @override
  Future<void> recordBreadcrumb(
    String message, {
    Map<String, Object?> keys = const {},
  }) async {}

  @override
  Future<void> recordFatal(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?> keys = const {},
  }) async {}

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {}

  @override
  Future<void> recordNonFatal(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?> keys = const {},
  }) async {
    nonFatalErrors.add(error);
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setContextKey(String key, Object value) async {}
}

class FakeAnalyticsClient implements AnalyticsClient {
  final List<(String, Map<String, Object>?)> events = [];
  final List<(String, Map<String, Object>?)> screenViews = [];
  final Map<String, String?> userProperties = {};
  bool? collectionEnabled;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    events.add((name, parameters));
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    Map<String, Object>? parameters,
  }) async {
    screenViews.add((screenName, parameters));
  }

  @override
  Future<void> setAnalyticsCollectionEnabled({required bool enabled}) async {
    collectionEnabled = enabled;
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    userProperties[name] = value;
  }
}

class FakeAppInfoProvider implements AppInfoProvider {
  @override
  String getBuildType() => 'debug';

  @override
  Future<String> getAppVersion() async => '1.0.0+1';
}

class TestCubit extends Cubit<int> {
  TestCubit() : super(0);
}

void main() {
  tearDown(() async {
    await locator.reset();
  });

  test('network info should forward connection status', () async {
    // arrange
    final networkInfo = NetworkInfoImpl(FakeChecker(true));

    // act
    final result = await networkInfo.isConnected;

    // assert
    expect(result, true);
  });

  test('paged response dto should map json and back', () {
    // arrange
    final dto = PagedResponseDto<int>.fromJson(
      {
        'page': 1,
        'results': [
          {'value': 1},
          {'value': 2},
        ],
        'total_pages': 2,
        'total_results': 2,
      },
      (json) => json['value'] as int,
      where: (item) => item > 1,
    );

    // act
    final json = dto.toPagedJson((item) => {'value': item});

    // assert
    expect(dto.results, [2]);
    expect(json['total_pages'], 2);
    expect(json['results'], [
      {'value': 2},
    ]);
  });

  test('core injection should register shared dependencies', () {
    // arrange
    registerCoreDependencies();

    // assert
    expect(locator.isRegistered<NetworkInfo>(), true);
    expect(locator.isRegistered<Client>(), true);
    expect(locator.isRegistered<DataConnectionChecker>(), true);
  });

  test('crashlytics collection should stay off in debug and test', () {
    expect(
      shouldEnableCrashlyticsCollection(
        isReleaseMode: false,
        isProfileMode: false,
      ),
      false,
    );
  });

  test('crashlytics collection should turn on in profile or release', () {
    expect(
      shouldEnableCrashlyticsCollection(
        isReleaseMode: false,
        isProfileMode: true,
      ),
      true,
    );
    expect(
      shouldEnableCrashlyticsCollection(
        isReleaseMode: true,
        isProfileMode: false,
      ),
      true,
    );
  });

  test('bloc observer should forward bloc error to crash reporter', () async {
    final crashReporter = FakeCrashReporter();
    final observer = AppBlocObserver(crashReporter);
    final cubit = TestCubit();
    final error = StateError('boom');

    observer.onError(cubit, error, StackTrace.empty);

    await Future<void>.delayed(Duration.zero);

    expect(crashReporter.nonFatalErrors, [error]);
    await cubit.close();
  });

  test('analytics collection should stay off in debug and test', () {
    expect(
      shouldEnableAnalyticsCollection(
        isReleaseMode: false,
        isProfileMode: false,
      ),
      false,
    );
  });

  test('analytics collection should turn on in profile or release', () {
    expect(
      shouldEnableAnalyticsCollection(
        isReleaseMode: false,
        isProfileMode: true,
      ),
      true,
    );
    expect(
      shouldEnableAnalyticsCollection(
        isReleaseMode: true,
        isProfileMode: false,
      ),
      true,
    );
  });

  test('analytics tracker should forward event and screen view', () async {
    final client = FakeAnalyticsClient();
    final tracker = FirebaseAnalyticsTracker(client: client);

    await tracker.logEvent(
      'watchlist_added',
      params: {'content_id': 1, 'feature': 'movie'},
    );
    await tracker.logScreenView(
      screenName: 'movie_detail',
      feature: 'movie',
      params: {'content_id': 1},
    );
    await tracker.setUserProperty(name: 'app_version', value: '1.0.0+1');

    expect(client.events.single.$1, 'watchlist_added');
    expect(client.events.single.$2?['content_id'], 1);
    expect(client.screenViews.single.$1, 'movie_detail');
    expect(client.screenViews.single.$2?['feature'], 'movie');
    expect(client.userProperties['app_version'], '1.0.0+1');
  });

  testWidgets('route tracking scope should log screen view once', (
    tester,
  ) async {
    final client = FakeAnalyticsClient();
    locator.registerSingleton<AnalyticsTracker>(
      FirebaseAnalyticsTracker(client: client),
    );
    locator.registerSingleton<CrashReporter>(FakeCrashReporter());

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AppRouteTrackingScope(
          routeName: 'movies-detail',
          screenName: 'movie_detail',
          feature: 'movie',
          contentType: 'movie',
          contentId: 1,
          child: SizedBox.shrink(),
        ),
      ),
    );
    await tester.pump();

    expect(client.screenViews.length, 1);
    expect(client.screenViews.single.$1, 'movie_detail');
    expect(client.screenViews.single.$2?['content_id'], 1);
  });
}
