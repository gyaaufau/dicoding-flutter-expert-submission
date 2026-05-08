import 'dart:async';

import 'package:dependencies/dependencies.dart';

import 'crash_reporter.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._crashReporter);

  final CrashReporter _crashReporter;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    unawaited(
      _crashReporter.recordNonFatal(
        error,
        stackTrace,
        reason: 'bloc_error',
        keys: {'bloc_type': bloc.runtimeType.toString()},
      ),
    );
    super.onError(bloc, error, stackTrace);
  }
}
