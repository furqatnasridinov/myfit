import 'dart:async';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ya_map.dart';
import 'package:activity/presentation/pages/main2/widget/main2_header.dart';
import 'package:activity/presentation/pages/main2/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@RoutePage()
class Main2Screen extends StatefulWidget {
  const Main2Screen({super.key});

  @override
  State<Main2Screen> createState() => _LoginScreen();
}

class _LoginScreen extends State<Main2Screen> {
  final mapControllerCompleter = Completer<YandexMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const Main2Header(),
      body: SafeArea(
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView(
                //padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  10.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: 'Привет, George!',
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const FirstTwoCards(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child:  ComingActivity(),
                  ),
                  32.verticalSpace, 
                  Padding(
                    padding: EdgeInsets.only(left: 25.w),
                    child: CustomText(
                      text: 'Бассейны поблизости',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  10.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const UiYaMap(),
                  ),
                  70.verticalSpace,
                  const DecoratedTextOne(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
