// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:activity/application/schedule/schedule_notifier.dart' as _i5;
import 'package:activity/application/schedule/schedule_state.dart' as _i6;
import 'package:activity/presentation/pages/activity/view/activity_page.dart'
    as _i1;
import 'package:activity/presentation/pages/main/view/main_page.dart' as _i2;
import 'package:activity/presentation/pages/schedule/view/schedule_page.dart'
    as _i3;
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i7;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    ActivityRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ActivityScreen(),
      );
    },
    MainRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.MainScreen(),
      );
    },
    ScheduleRoute.name: (routeData) {
      final args = routeData.argsAs<ScheduleRouteArgs>();
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.ScheduleScreen(
          event: args.event,
          state: args.state,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.ActivityScreen]
class ActivityRoute extends _i4.PageRouteInfo<void> {
  const ActivityRoute({List<_i4.PageRouteInfo>? children})
      : super(
          ActivityRoute.name,
          initialChildren: children,
        );

  static const String name = 'ActivityRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.MainScreen]
class MainRoute extends _i4.PageRouteInfo<void> {
  const MainRoute({List<_i4.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ScheduleScreen]
class ScheduleRoute extends _i4.PageRouteInfo<ScheduleRouteArgs> {
  ScheduleRoute({
    required _i5.ScheduleNotifier event,
    required _i6.ScheduleState state,
    _i7.Key? key,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          ScheduleRoute.name,
          args: ScheduleRouteArgs(
            event: event,
            state: state,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ScheduleRoute';

  static const _i4.PageInfo<ScheduleRouteArgs> page =
      _i4.PageInfo<ScheduleRouteArgs>(name);
}

class ScheduleRouteArgs {
  const ScheduleRouteArgs({
    required this.event,
    required this.state,
    this.key,
  });

  final _i5.ScheduleNotifier event;

  final _i6.ScheduleState state;

  final _i7.Key? key;

  @override
  String toString() {
    return 'ScheduleRouteArgs{event: $event, state: $state, key: $key}';
  }
}
