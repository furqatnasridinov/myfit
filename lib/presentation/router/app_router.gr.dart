// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i23;
import 'package:flutter/material.dart' as _i24;
import 'package:myfit/infrastructure/models/data/membership.dart' as _i25;
import 'package:myfit/presentation/pages/activity/view/activity_page.dart'
    as _i1;
import 'package:myfit/presentation/pages/auth/registration/registration_page.dart'
    as _i18;
import 'package:myfit/presentation/pages/auth/registration1/registration1_page.dart'
    as _i14;
import 'package:myfit/presentation/pages/auth/registration2/registration2.dart'
    as _i15;
import 'package:myfit/presentation/pages/auth/registration3/registration3.dart'
    as _i16;
import 'package:myfit/presentation/pages/auth/registration4/registration4_page.dart'
    as _i17;
import 'package:myfit/presentation/pages/bottom_navigation_handler.dart' as _i2;
import 'package:myfit/presentation/pages/buy_membership/buy_membership_screen.dart'
    as _i3;
import 'package:myfit/presentation/pages/buy_membership/membership_details.dart'
    as _i7;
import 'package:myfit/presentation/pages/main/view/main_page.dart' as _i5;
import 'package:myfit/presentation/pages/main2/view/main2_page.dart' as _i4;
import 'package:myfit/presentation/pages/map/view/map_page.dart' as _i6;
import 'package:myfit/presentation/pages/memberships/memberships_page.dart'
    as _i8;
import 'package:myfit/presentation/pages/notes/view/notes_page.dart' as _i9;
import 'package:myfit/presentation/pages/notification/view/notification_page.dart'
    as _i10;
import 'package:myfit/presentation/pages/payments_settings/payment_settings_screen.dart'
    as _i11;
import 'package:myfit/presentation/pages/photo_view/photo_view.dart' as _i12;
import 'package:myfit/presentation/pages/qr_scanner/view/qr_code_page.dart'
    as _i13;
import 'package:myfit/presentation/pages/schedule/view/schedule_page.dart'
    as _i19;
import 'package:myfit/presentation/pages/settings/view/settings_page.dart'
    as _i20;
import 'package:myfit/presentation/pages/splash/splash_screen.dart' as _i21;
import 'package:myfit/presentation/pages/subscribtion_settings/view/subscribtion_settings_page.dart'
    as _i22;

abstract class $AppRouter extends _i23.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i23.PageFactory> pagesMap = {
    ActivityRoute.name: (routeData) {
      final args = routeData.argsAs<ActivityRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ActivityScreen(
          key: args.key,
          isFromMap: args.isFromMap,
          gymId: args.gymId,
        ),
      );
    },
    BottomNavigationHandlerRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.BottomNavigationHandlerScreen(),
      );
    },
    BuyMembershipRoute.name: (routeData) {
      final args = routeData.argsAs<BuyMembershipRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.BuyMembershipScreen(
          key: args.key,
          gymId: args.gymId,
        ),
      );
    },
    Main2Route.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.Main2Screen(),
      );
    },
    MainRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.MainScreen(),
      );
    },
    MapRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.MapScreen(),
      );
    },
    MembershipDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<MembershipDetailsRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.MembershipDetailsScreen(
          key: args.key,
          membership: args.membership,
          boughtAlready: args.boughtAlready,
        ),
      );
    },
    MembershipsRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MembershipsScreen(),
      );
    },
    NotesRoute.name: (routeData) {
      final args = routeData.argsAs<NotesRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.NotesScreen(
          key: args.key,
          gymName: args.gymName,
        ),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.NotificationScreen(),
      );
    },
    PaymentSettingsRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.PaymentSettingsScreen(),
      );
    },
    PhotoViewRoute.name: (routeData) {
      final args = routeData.argsAs<PhotoViewRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.PhotoViewScreen(
          key: args.key,
          photos: args.photos,
          index: args.index,
        ),
      );
    },
    QrCodeRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.QrCodeScreen(),
      );
    },
    Registration1Route.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.Registration1Screen(),
      );
    },
    Registration2Route.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.Registration2Screen(),
      );
    },
    Registration3Route.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.Registration3Screen(),
      );
    },
    Registration4Route.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.Registration4Screen(),
      );
    },
    RegistrationRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.RegistrationScreen(),
      );
    },
    ScheduleRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.ScheduleScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.SettingsScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.SplashScreen(),
      );
    },
    SubscribtionSettingsRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i22.SubscribtionSettingsScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.ActivityScreen]
class ActivityRoute extends _i23.PageRouteInfo<ActivityRouteArgs> {
  ActivityRoute({
    _i24.Key? key,
    bool? isFromMap = false,
    required int gymId,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          ActivityRoute.name,
          args: ActivityRouteArgs(
            key: key,
            isFromMap: isFromMap,
            gymId: gymId,
          ),
          initialChildren: children,
        );

  static const String name = 'ActivityRoute';

  static const _i23.PageInfo<ActivityRouteArgs> page =
      _i23.PageInfo<ActivityRouteArgs>(name);
}

class ActivityRouteArgs {
  const ActivityRouteArgs({
    this.key,
    this.isFromMap = false,
    required this.gymId,
  });

  final _i24.Key? key;

  final bool? isFromMap;

  final int gymId;

  @override
  String toString() {
    return 'ActivityRouteArgs{key: $key, isFromMap: $isFromMap, gymId: $gymId}';
  }
}

/// generated route for
/// [_i2.BottomNavigationHandlerScreen]
class BottomNavigationHandlerRoute extends _i23.PageRouteInfo<void> {
  const BottomNavigationHandlerRoute({List<_i23.PageRouteInfo>? children})
      : super(
          BottomNavigationHandlerRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationHandlerRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i3.BuyMembershipScreen]
class BuyMembershipRoute extends _i23.PageRouteInfo<BuyMembershipRouteArgs> {
  BuyMembershipRoute({
    _i24.Key? key,
    required int gymId,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          BuyMembershipRoute.name,
          args: BuyMembershipRouteArgs(
            key: key,
            gymId: gymId,
          ),
          initialChildren: children,
        );

  static const String name = 'BuyMembershipRoute';

  static const _i23.PageInfo<BuyMembershipRouteArgs> page =
      _i23.PageInfo<BuyMembershipRouteArgs>(name);
}

class BuyMembershipRouteArgs {
  const BuyMembershipRouteArgs({
    this.key,
    required this.gymId,
  });

  final _i24.Key? key;

  final int gymId;

  @override
  String toString() {
    return 'BuyMembershipRouteArgs{key: $key, gymId: $gymId}';
  }
}

/// generated route for
/// [_i4.Main2Screen]
class Main2Route extends _i23.PageRouteInfo<void> {
  const Main2Route({List<_i23.PageRouteInfo>? children})
      : super(
          Main2Route.name,
          initialChildren: children,
        );

  static const String name = 'Main2Route';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i5.MainScreen]
class MainRoute extends _i23.PageRouteInfo<void> {
  const MainRoute({List<_i23.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i6.MapScreen]
class MapRoute extends _i23.PageRouteInfo<void> {
  const MapRoute({List<_i23.PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i7.MembershipDetailsScreen]
class MembershipDetailsRoute
    extends _i23.PageRouteInfo<MembershipDetailsRouteArgs> {
  MembershipDetailsRoute({
    _i24.Key? key,
    required _i25.MemberShip membership,
    bool? boughtAlready = false,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          MembershipDetailsRoute.name,
          args: MembershipDetailsRouteArgs(
            key: key,
            membership: membership,
            boughtAlready: boughtAlready,
          ),
          initialChildren: children,
        );

  static const String name = 'MembershipDetailsRoute';

  static const _i23.PageInfo<MembershipDetailsRouteArgs> page =
      _i23.PageInfo<MembershipDetailsRouteArgs>(name);
}

class MembershipDetailsRouteArgs {
  const MembershipDetailsRouteArgs({
    this.key,
    required this.membership,
    this.boughtAlready = false,
  });

  final _i24.Key? key;

  final _i25.MemberShip membership;

  final bool? boughtAlready;

  @override
  String toString() {
    return 'MembershipDetailsRouteArgs{key: $key, membership: $membership, boughtAlready: $boughtAlready}';
  }
}

/// generated route for
/// [_i8.MembershipsScreen]
class MembershipsRoute extends _i23.PageRouteInfo<void> {
  const MembershipsRoute({List<_i23.PageRouteInfo>? children})
      : super(
          MembershipsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MembershipsRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i9.NotesScreen]
class NotesRoute extends _i23.PageRouteInfo<NotesRouteArgs> {
  NotesRoute({
    _i24.Key? key,
    required String gymName,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          NotesRoute.name,
          args: NotesRouteArgs(
            key: key,
            gymName: gymName,
          ),
          initialChildren: children,
        );

  static const String name = 'NotesRoute';

  static const _i23.PageInfo<NotesRouteArgs> page =
      _i23.PageInfo<NotesRouteArgs>(name);
}

class NotesRouteArgs {
  const NotesRouteArgs({
    this.key,
    required this.gymName,
  });

  final _i24.Key? key;

  final String gymName;

  @override
  String toString() {
    return 'NotesRouteArgs{key: $key, gymName: $gymName}';
  }
}

/// generated route for
/// [_i10.NotificationScreen]
class NotificationRoute extends _i23.PageRouteInfo<void> {
  const NotificationRoute({List<_i23.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i11.PaymentSettingsScreen]
class PaymentSettingsRoute extends _i23.PageRouteInfo<void> {
  const PaymentSettingsRoute({List<_i23.PageRouteInfo>? children})
      : super(
          PaymentSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaymentSettingsRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i12.PhotoViewScreen]
class PhotoViewRoute extends _i23.PageRouteInfo<PhotoViewRouteArgs> {
  PhotoViewRoute({
    _i24.Key? key,
    required List<String> photos,
    required int index,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          PhotoViewRoute.name,
          args: PhotoViewRouteArgs(
            key: key,
            photos: photos,
            index: index,
          ),
          initialChildren: children,
        );

  static const String name = 'PhotoViewRoute';

  static const _i23.PageInfo<PhotoViewRouteArgs> page =
      _i23.PageInfo<PhotoViewRouteArgs>(name);
}

class PhotoViewRouteArgs {
  const PhotoViewRouteArgs({
    this.key,
    required this.photos,
    required this.index,
  });

  final _i24.Key? key;

  final List<String> photos;

  final int index;

  @override
  String toString() {
    return 'PhotoViewRouteArgs{key: $key, photos: $photos, index: $index}';
  }
}

/// generated route for
/// [_i13.QrCodeScreen]
class QrCodeRoute extends _i23.PageRouteInfo<void> {
  const QrCodeRoute({List<_i23.PageRouteInfo>? children})
      : super(
          QrCodeRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrCodeRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i14.Registration1Screen]
class Registration1Route extends _i23.PageRouteInfo<void> {
  const Registration1Route({List<_i23.PageRouteInfo>? children})
      : super(
          Registration1Route.name,
          initialChildren: children,
        );

  static const String name = 'Registration1Route';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i15.Registration2Screen]
class Registration2Route extends _i23.PageRouteInfo<void> {
  const Registration2Route({List<_i23.PageRouteInfo>? children})
      : super(
          Registration2Route.name,
          initialChildren: children,
        );

  static const String name = 'Registration2Route';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i16.Registration3Screen]
class Registration3Route extends _i23.PageRouteInfo<void> {
  const Registration3Route({List<_i23.PageRouteInfo>? children})
      : super(
          Registration3Route.name,
          initialChildren: children,
        );

  static const String name = 'Registration3Route';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i17.Registration4Screen]
class Registration4Route extends _i23.PageRouteInfo<void> {
  const Registration4Route({List<_i23.PageRouteInfo>? children})
      : super(
          Registration4Route.name,
          initialChildren: children,
        );

  static const String name = 'Registration4Route';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i18.RegistrationScreen]
class RegistrationRoute extends _i23.PageRouteInfo<void> {
  const RegistrationRoute({List<_i23.PageRouteInfo>? children})
      : super(
          RegistrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i19.ScheduleScreen]
class ScheduleRoute extends _i23.PageRouteInfo<void> {
  const ScheduleRoute({List<_i23.PageRouteInfo>? children})
      : super(
          ScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScheduleRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i20.SettingsScreen]
class SettingsRoute extends _i23.PageRouteInfo<void> {
  const SettingsRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i21.SplashScreen]
class SplashRoute extends _i23.PageRouteInfo<void> {
  const SplashRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i22.SubscribtionSettingsScreen]
class SubscribtionSettingsRoute extends _i23.PageRouteInfo<void> {
  const SubscribtionSettingsRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SubscribtionSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SubscribtionSettingsRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}
