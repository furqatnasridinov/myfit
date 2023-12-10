// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:activity/presentation/pages/activity/view/activity_page.dart'
    as _i1;
import 'package:activity/presentation/pages/auth/registration/registration_page.dart'
    as _i10;
import 'package:activity/presentation/pages/auth/registration1/registration1_page.dart'
    as _i6;
import 'package:activity/presentation/pages/auth/registration2/registration2.dart'
    as _i7;
import 'package:activity/presentation/pages/auth/registration3/registration3.dart'
    as _i8;
import 'package:activity/presentation/pages/auth/registration4/registration4_page.dart'
    as _i9;
import 'package:activity/presentation/pages/main/view/main_page.dart' as _i3;
import 'package:activity/presentation/pages/main2/view/main2_page.dart' as _i2;
import 'package:activity/presentation/pages/map/view/map_page.dart' as _i4;
import 'package:activity/presentation/pages/notes/view/notes_page.dart' as _i5;
import 'package:activity/presentation/pages/schedule/view/schedule_page.dart'
    as _i11;
import 'package:activity/presentation/pages/settings/view/settings_page.dart'
    as _i12;
import 'package:activity/presentation/pages/splash/splash_screen.dart' as _i13;
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:flutter/foundation.dart' as _i15;
import 'package:flutter/material.dart' as _i16;

abstract class $AppRouter extends _i14.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    ActivityRoute.name: (routeData) {
      final args = routeData.argsAs<ActivityRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ActivityScreen(
          gymId: args.gymId,
          key: args.key,
        ),
      );
    },
    Main2Route.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.Main2Screen(),
      );
    },
    MainRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.MainScreen(),
      );
    },
    MapRoute.name: (routeData) {
      final args = routeData.argsAs<MapRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.MapScreen(
          args.gymId,
          key: args.key,
        ),
      );
    },
    NotesRoute.name: (routeData) {
      final args = routeData.argsAs<NotesRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.NotesScreen(
          key: args.key,
          gymName: args.gymName,
        ),
      );
    },
    Registration1Route.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.Registration1Screen(),
      );
    },
    Registration2Route.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.Registration2Screen(),
      );
    },
    Registration3Route.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.Registration3Screen(),
      );
    },
    Registration4Route.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.Registration4Screen(),
      );
    },
    RegistrationRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.RegistrationScreen(),
      );
    },
    ScheduleRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.ScheduleScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SettingsScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.ActivityScreen]
class ActivityRoute extends _i14.PageRouteInfo<ActivityRouteArgs> {
  ActivityRoute({
    required int gymId,
    _i15.Key? key,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          ActivityRoute.name,
          args: ActivityRouteArgs(
            gymId: gymId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ActivityRoute';

  static const _i14.PageInfo<ActivityRouteArgs> page =
      _i14.PageInfo<ActivityRouteArgs>(name);
}

class ActivityRouteArgs {
  const ActivityRouteArgs({
    required this.gymId,
    this.key,
  });

  final int gymId;

  final _i15.Key? key;

  @override
  String toString() {
    return 'ActivityRouteArgs{gymId: $gymId, key: $key}';
  }
}

/// generated route for
/// [_i2.Main2Screen]
class Main2Route extends _i14.PageRouteInfo<void> {
  const Main2Route({List<_i14.PageRouteInfo>? children})
      : super(
          Main2Route.name,
          initialChildren: children,
        );

  static const String name = 'Main2Route';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i3.MainScreen]
class MainRoute extends _i14.PageRouteInfo<void> {
  const MainRoute({List<_i14.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MapScreen]
class MapRoute extends _i14.PageRouteInfo<MapRouteArgs> {
  MapRoute({
    required int? gymId,
    _i15.Key? key,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          MapRoute.name,
          args: MapRouteArgs(
            gymId: gymId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const _i14.PageInfo<MapRouteArgs> page =
      _i14.PageInfo<MapRouteArgs>(name);
}

class MapRouteArgs {
  const MapRouteArgs({
    required this.gymId,
    this.key,
  });

  final int? gymId;

  final _i15.Key? key;

  @override
  String toString() {
    return 'MapRouteArgs{gymId: $gymId, key: $key}';
  }
}

/// generated route for
/// [_i5.NotesScreen]
class NotesRoute extends _i14.PageRouteInfo<NotesRouteArgs> {
  NotesRoute({
    _i16.Key? key,
    required String gymName,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          NotesRoute.name,
          args: NotesRouteArgs(
            key: key,
            gymName: gymName,
          ),
          initialChildren: children,
        );

  static const String name = 'NotesRoute';

  static const _i14.PageInfo<NotesRouteArgs> page =
      _i14.PageInfo<NotesRouteArgs>(name);
}

class NotesRouteArgs {
  const NotesRouteArgs({
    this.key,
    required this.gymName,
  });

  final _i16.Key? key;

  final String gymName;

  @override
  String toString() {
    return 'NotesRouteArgs{key: $key, gymName: $gymName}';
  }
}

/// generated route for
/// [_i6.Registration1Screen]
class Registration1Route extends _i14.PageRouteInfo<void> {
  const Registration1Route({List<_i14.PageRouteInfo>? children})
      : super(
          Registration1Route.name,
          initialChildren: children,
        );

  static const String name = 'Registration1Route';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i7.Registration2Screen]
class Registration2Route extends _i14.PageRouteInfo<void> {
  const Registration2Route({List<_i14.PageRouteInfo>? children})
      : super(
          Registration2Route.name,
          initialChildren: children,
        );

  static const String name = 'Registration2Route';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i8.Registration3Screen]
class Registration3Route extends _i14.PageRouteInfo<void> {
  const Registration3Route({List<_i14.PageRouteInfo>? children})
      : super(
          Registration3Route.name,
          initialChildren: children,
        );

  static const String name = 'Registration3Route';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i9.Registration4Screen]
class Registration4Route extends _i14.PageRouteInfo<void> {
  const Registration4Route({List<_i14.PageRouteInfo>? children})
      : super(
          Registration4Route.name,
          initialChildren: children,
        );

  static const String name = 'Registration4Route';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i10.RegistrationScreen]
class RegistrationRoute extends _i14.PageRouteInfo<void> {
  const RegistrationRoute({List<_i14.PageRouteInfo>? children})
      : super(
          RegistrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ScheduleScreen]
class ScheduleRoute extends _i14.PageRouteInfo<void> {
  const ScheduleRoute({List<_i14.PageRouteInfo>? children})
      : super(
          ScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScheduleRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SettingsScreen]
class SettingsRoute extends _i14.PageRouteInfo<void> {
  const SettingsRoute({List<_i14.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SplashScreen]
class SplashRoute extends _i14.PageRouteInfo<void> {
  const SplashRoute({List<_i14.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}
