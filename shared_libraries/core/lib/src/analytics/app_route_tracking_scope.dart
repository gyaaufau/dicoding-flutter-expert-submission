import 'dart:async';

import 'package:flutter/widgets.dart';

import '../crashlytics/crash_reporter.dart';
import '../di/locator.dart';
import 'analytics_tracker.dart';

class AppRouteTrackingScope extends StatefulWidget {
  const AppRouteTrackingScope({
    super.key,
    required this.routeName,
    required this.screenName,
    required this.feature,
    required this.child,
    this.contentType,
    this.contentId,
    this.trackScreenView = true,
  });

  final String routeName;
  final String screenName;
  final String feature;
  final Widget child;
  final String? contentType;
  final int? contentId;
  final bool trackScreenView;

  @override
  State<AppRouteTrackingScope> createState() => _AppRouteTrackingScopeState();
}

class _AppRouteTrackingScopeState extends State<AppRouteTrackingScope> {
  String? _lastSignature;

  @override
  void initState() {
    super.initState();
    _syncTracking();
  }

  @override
  void didUpdateWidget(covariant AppRouteTrackingScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTracking();
  }

  void _syncTracking() {
    final signature = [
      widget.routeName,
      widget.screenName,
      widget.feature,
      widget.contentType,
      widget.contentId,
      widget.trackScreenView,
    ].join('|');

    if (_lastSignature == signature) {
      return;
    }
    _lastSignature = signature;

    if (locator.isRegistered<CrashReporter>()) {
      final reporter = locator<CrashReporter>();
      unawaited(reporter.setContextKey('route_name', widget.routeName));
      unawaited(reporter.setContextKey('feature', widget.feature));
      if (widget.contentId != null) {
        unawaited(reporter.setContextKey('entity_id', widget.contentId!));
      }
    }

    if (!widget.trackScreenView || !locator.isRegistered<AnalyticsTracker>()) {
      return;
    }

    unawaited(
      locator<AnalyticsTracker>().logScreenView(
        screenName: widget.screenName,
        feature: widget.feature,
        params: {
          'entity_type': widget.contentType,
          'content_type': widget.contentType,
          'content_id': widget.contentId,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
