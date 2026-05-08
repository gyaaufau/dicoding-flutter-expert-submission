import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';

bool shouldEnableCrashlyticsCollection({
  bool isReleaseMode = kReleaseMode,
  bool isProfileMode = kProfileMode,
}) {
  return isReleaseMode || isProfileMode;
}

abstract class CrashReporter {
  Future<void> setCollectionEnabled(bool enabled);

  Future<void> recordFatal(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?> keys = const {},
  });

  Future<void> recordNonFatal(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?> keys = const {},
  });

  Future<void> recordFlutterFatalError(FlutterErrorDetails details);

  Future<void> setContextKey(String key, Object value);

  Future<void> recordBreadcrumb(
    String message, {
    Map<String, Object?> keys = const {},
  });
}

class FirebaseCrashReporter implements CrashReporter {
  FirebaseCrashReporter({FirebaseCrashlytics? crashlytics})
    : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> setCollectionEnabled(bool enabled) {
    return _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  @override
  Future<void> recordFatal(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?> keys = const {},
  }) async {
    await _applyKeys(keys);
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: true,
    );
  }

  @override
  Future<void> recordNonFatal(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?> keys = const {},
  }) async {
    await _applyKeys(keys);
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: false,
    );
  }

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {
    await _crashlytics.recordFlutterFatalError(details);
  }

  @override
  Future<void> setContextKey(String key, Object value) {
    return _crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> recordBreadcrumb(
    String message, {
    Map<String, Object?> keys = const {},
  }) async {
    await _applyKeys(keys);
    await _crashlytics.log(message);
  }

  Future<void> _applyKeys(Map<String, Object?> keys) async {
    for (final entry in keys.entries) {
      final value = entry.value;
      if (value == null) {
        continue;
      }
      await _crashlytics.setCustomKey(entry.key, value);
    }
  }
}
