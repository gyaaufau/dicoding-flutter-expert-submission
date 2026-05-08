import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';

bool shouldEnableAnalyticsCollection({
  bool isReleaseMode = kReleaseMode,
  bool isProfileMode = kProfileMode,
}) {
  return isReleaseMode || isProfileMode;
}

String currentBuildType({
  bool isReleaseMode = kReleaseMode,
  bool isProfileMode = kProfileMode,
}) {
  if (isReleaseMode) {
    return 'release';
  }
  if (isProfileMode) {
    return 'profile';
  }
  return 'debug';
}

abstract class AnalyticsClient {
  Future<void> setAnalyticsCollectionEnabled({required bool enabled});

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  Future<void> logScreenView({
    required String screenName,
    Map<String, Object>? parameters,
  });

  Future<void> setUserProperty({required String name, required String? value});
}

class FirebaseAnalyticsClient implements AnalyticsClient {
  FirebaseAnalyticsClient({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  @override
  Future<void> setAnalyticsCollectionEnabled({required bool enabled}) {
    return _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    Map<String, Object>? parameters,
  }) {
    return _analytics.logScreenView(
      screenName: screenName,
      parameters: parameters,
    );
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    return _analytics.setUserProperty(name: name, value: value);
  }
}

abstract class AnalyticsTracker {
  Future<void> setAnalyticsCollectionEnabled(bool enabled);

  Future<void> logEvent(String name, {Map<String, Object?> params = const {}});

  Future<void> logScreenView({
    required String screenName,
    String? feature,
    Map<String, Object?> params = const {},
  });

  Future<void> setUserProperty({required String name, required String? value});
}

class FirebaseAnalyticsTracker implements AnalyticsTracker {
  FirebaseAnalyticsTracker({AnalyticsClient? client})
    : _client = client ?? FirebaseAnalyticsClient();

  final AnalyticsClient _client;

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) {
    return _client.setAnalyticsCollectionEnabled(enabled: enabled);
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object?> params = const {}}) {
    return _client.logEvent(name: name, parameters: _normalizeParams(params));
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? feature,
    Map<String, Object?> params = const {},
  }) {
    final normalized = _normalizeParams({'feature': feature, ...params});
    return _client.logScreenView(
      screenName: screenName,
      parameters: normalized,
    );
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    return _client.setUserProperty(name: name, value: value);
  }

  Map<String, Object> _normalizeParams(Map<String, Object?> params) {
    final normalized = <String, Object>{};
    for (final entry in params.entries) {
      final value = entry.value;
      if (value == null) {
        continue;
      }
      if (value is String || value is num || value is bool) {
        normalized[entry.key] = value;
      } else {
        normalized[entry.key] = value.toString();
      }
    }
    return normalized;
  }
}
