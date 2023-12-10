import 'package:activity/domain/di/dependency_manager.dart';
import 'package:activity/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AppWidget extends StatelessWidget {
  AppWidget({super.key});
  AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    AndroidYandexMap.useAndroidViewSurface = false;

    return FutureBuilder(
      future: Future.wait(
        [
          setUpDependencies(),
        ],
      ),
      builder: (context, snapshot) {
        return ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp.router(
              routerConfig: appRouter.config(),
              debugShowCheckedModeBanner: false,
              //home: ActivityPage(id: 1),
            );
          },
        );
      },
    );
  }
}
