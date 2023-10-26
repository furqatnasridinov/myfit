import 'package:activity/domain/di/dependency_manager.dart';
import 'package:activity/presentation/pages/activity/view/activity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([setUpDependencies()]),
      builder: (context, snapshot) {
        return ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          designSize: const Size(375, 812),
          builder: (context, child) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ActivityPage(id: 1),
            );
          },
        );
      },
    );
  }
}
