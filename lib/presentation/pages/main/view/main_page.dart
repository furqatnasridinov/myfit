import 'package:activity/presentation/components/header.dart';
import 'package:activity/presentation/pages/main/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _BlogScreen();
}

class _BlogScreen extends State<MainScreen> {
  int activeStepState = 1;
  int dotCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Container(
        margin: EdgeInsets.only(top: 27.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView(
            children: [
              const TheOneWithCards(),
              32.verticalSpace,
              TheOneAboutBenefits(),
              32.verticalSpace,
              const TheOneWithMap(),
              32.verticalSpace,
              const TheOneWithButton(),
              32.verticalSpace,
              const TheOneWithReview(),
              32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
