// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:activity/application/schedule/schedule_notifier.dart' as _i7;
import 'package:activity/application/schedule/schedule_state.dart' as _i8;
import 'package:activity/presentation/pages/activity/view/activity_page.dart'
    as _i1;
import 'package:activity/presentation/pages/main/view/main_page.dart' as _i3;
import 'package:activity/presentation/pages/main2/view/main2_page.dart' as _i2;
import 'package:activity/presentation/pages/notes/view/notes_page.dart' as _i4;
import 'package:activity/presentation/pages/schedule/view/schedule_page.dart'
    as _i5;
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i9;

abstract class $AppRouter extends _i6.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    ActivityRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ActivityScreen(),
      );
    },
    Main2Route.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.Main2Screen(),
      );
    },
    MainRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.MainScreen(),
      );
    },
    NotesRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.NotesScreen(),
      );
    },
    ScheduleRoute.name: (routeData) {
      final args = routeData.argsAs<ScheduleRouteArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ScheduleScreen(
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
class ActivityRoute extends _i6.PageRouteInfo<void> {
  const ActivityRoute({List<_i6.PageRouteInfo>? children})
      : super(
          ActivityRoute.name,
          initialChildren: children,
        );

  static const String name = 'ActivityRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i2.Main2Screen]
class Main2Route extends _i6.PageRouteInfo<void> {
  const Main2Route({List<_i6.PageRouteInfo>? children})
      : super(
          Main2Route.name,
          initialChildren: children,
        );

  static const String name = 'Main2Route';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.MainScreen]
class MainRoute extends _i6.PageRouteInfo<void> {
  const MainRoute({List<_i6.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i4.NotesScreen]
class NotesRoute extends _i6.PageRouteInfo<void> {
  const NotesRoute({List<_i6.PageRouteInfo>? children})
      : super(
          NotesRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotesRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ScheduleScreen]
class ScheduleRoute extends _i6.PageRouteInfo<ScheduleRouteArgs> {
  ScheduleRoute({
    required _i7.ScheduleNotifier event,
    required _i8.ScheduleState state,
    _i9.Key? key,
    List<_i6.PageRouteInfo>? children,
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

  static const _i6.PageInfo<ScheduleRouteArgs> page =
      _i6.PageInfo<ScheduleRouteArgs>(name);
}

class ScheduleRouteArgs {
  const ScheduleRouteArgs({
    required this.event,
    required this.state,
    this.key,
  });

  final _i7.ScheduleNotifier event;

  final _i8.ScheduleState state;

  final _i9.Key? key;

  @override
  String toString() {
    return 'ScheduleRouteArgs{event: $event, state: $state, key: $key}';
  }
}
