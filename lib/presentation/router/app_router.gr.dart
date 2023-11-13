// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:activity/presentation/pages/activity/view/activity_page.dart'
    as _i1;
import 'package:activity/presentation/pages/main/view/main_page.dart' as _i3;
import 'package:activity/presentation/pages/main2/view/main2_page.dart' as _i2;
import 'package:activity/presentation/pages/map/view/map_page.dart' as _i4;
import 'package:activity/presentation/pages/notes/view/notes_page.dart' as _i5;
import 'package:activity/presentation/pages/schedule/view/schedule_page.dart'
    as _i6;
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    ActivityRoute.name: (routeData) {
      final args = routeData.argsAs<ActivityRouteArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ActivityScreen(
          gymId: args.gymId,
          key: args.key,
        ),
      );
    },
    Main2Route.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.Main2Screen(),
      );
    },
    MainRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.MainScreen(),
      );
    },
    MapRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.MapScreen(),
      );
    },
    NotesRoute.name: (routeData) {
      final args = routeData.argsAs<NotesRouteArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.NotesScreen(
          key: args.key,
          day: args.day,
        ),
      );
    },
    ScheduleRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ScheduleScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.ActivityScreen]
class ActivityRoute extends _i7.PageRouteInfo<ActivityRouteArgs> {
  ActivityRoute({
    required int gymId,
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          ActivityRoute.name,
          args: ActivityRouteArgs(
            gymId: gymId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ActivityRoute';

  static const _i7.PageInfo<ActivityRouteArgs> page =
      _i7.PageInfo<ActivityRouteArgs>(name);
}

class ActivityRouteArgs {
  const ActivityRouteArgs({
    required this.gymId,
    this.key,
  });

  final int gymId;

  final _i8.Key? key;

  @override
  String toString() {
    return 'ActivityRouteArgs{gymId: $gymId, key: $key}';
  }
}

/// generated route for
/// [_i2.Main2Screen]
class Main2Route extends _i7.PageRouteInfo<void> {
  const Main2Route({List<_i7.PageRouteInfo>? children})
      : super(
          Main2Route.name,
          initialChildren: children,
        );

  static const String name = 'Main2Route';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i3.MainScreen]
class MainRoute extends _i7.PageRouteInfo<void> {
  const MainRoute({List<_i7.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MapScreen]
class MapRoute extends _i7.PageRouteInfo<void> {
  const MapRoute({List<_i7.PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NotesScreen]
class NotesRoute extends _i7.PageRouteInfo<NotesRouteArgs> {
  NotesRoute({
    _i8.Key? key,
    required String day,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          NotesRoute.name,
          args: NotesRouteArgs(
            key: key,
            day: day,
          ),
          initialChildren: children,
        );

  static const String name = 'NotesRoute';

  static const _i7.PageInfo<NotesRouteArgs> page =
      _i7.PageInfo<NotesRouteArgs>(name);
}

class NotesRouteArgs {
  const NotesRouteArgs({
    this.key,
    required this.day,
  });

  final _i8.Key? key;

  final String day;

  @override
  String toString() {
    return 'NotesRouteArgs{key: $key, day: $day}';
  }
}

/// generated route for
/// [_i6.ScheduleScreen]
class ScheduleRoute extends _i7.PageRouteInfo<void> {
  const ScheduleRoute({List<_i7.PageRouteInfo>? children})
      : super(
          ScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScheduleRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
