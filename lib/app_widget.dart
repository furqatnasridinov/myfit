import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfit/application/notification/notification_notifier.dart';
import 'package:myfit/domain/di/dependency_manager.dart';
import 'package:myfit/presentation/router/app_router.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class AppWidget extends StatelessWidget {
  AppWidget({super.key});

  AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(
        [
          //setUpDependencies(),
        ],
      ),
      builder: (context, snapshot) {
        return ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          designSize: const Size(375, 812),
          builder: (context, child) {
            return Consumer(builder: (context, ref, child) {
              //final notifier = ref.read(settingsProvider.notifier);
              return MaterialApp.router(
              routerConfig: appRouter.config(
                  //navigatorObservers: () => [MyRouteObserver()],
                  deepLinkBuilder: (link) {
                    return DeepLink.defaultPath;
                // будет вызвано при переходе по динамической ссылке
                // only when app is in terminated state
                //log(link.path);
                /* if (link.path.contains("/inv")) {
                      /* try {
                        /* notifier
                          ..setIsFromReferalDeepLink(true)
                          ..setReferalDeepLinkValue(link.path); */
                        return const DeepLink([Main2Route(), SubscribtionSettingsRoute()]);
                      } catch (e) {
                        AppHelpers.showErrorSnack(context, e.toString());
                        return DeepLink.defaultPath;
                      } */
                     return DeepLink.defaultPath;
                    } else {
                  switch (link.path) {
                    case '/qrcode/page':
                      return const DeepLink([Main2Route(), QrCodeRoute()]);
                    case '/notification/page':
                      return const DeepLink([Main2Route(), NotificationRoute()]);
                    default:
                      return DeepLink.defaultPath;
                  }
                } */
              }),
              debugShowCheckedModeBanner: false,
            );
            },);
          },
        );
      },
    );
  }
}

class MyRouteObserver extends AutoRouteObserver {
  final NotificationNotifier notificationNotifier =
      NotificationNotifier(notificationRepo);
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final settings = route.settings;
    if (settings is AutoRoutePage) {
      final uri = settings.name;
      if (uri.toString().contains('/qrcode/page')) {
        const DeepLink([Main2Route(), QrCodeRoute()]);
      }
    }
    log('didPush ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    log('didPop ${route.settings.name}');
    if (route.settings.name == 'NotificationRoute') {
      log("yahaybalya");
      //notificationNotifier.onPopNotificationRoute();
    }
  }
}
