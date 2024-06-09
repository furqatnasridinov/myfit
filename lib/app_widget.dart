import 'dart:developer';
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
            return MaterialApp.router(
              routerConfig: appRouter.config(
                  navigatorObservers: () => [MyRouteObserver()],
                  deepLinkBuilder: (link) {
                    log(link.path);
                    if (link.path.contains('/qrcode/page')) {
                      return const DeepLink([Main2Route(),QrCodeRoute()]);
                      //context.router.push(const QrCodeRoute());
                    } else {
                      return DeepLink.defaultPath;
                    }
                  } 
                  ),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}

class MyRouteObserver extends AutoRouteObserver {
  final NotificationNotifier notificationNotifier = NotificationNotifier(notificationRepo);
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