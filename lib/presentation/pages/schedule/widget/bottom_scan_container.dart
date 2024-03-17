import 'package:activity/application/main2/main2_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomScanContainer extends StatelessWidget {
  const BottomScanContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final nearestLesson = ref.watch(main2Provider).nearestLesson;
      final isActivityStartingIn15Minutes =
          ref.watch(main2Provider).isActivityStartingIn15Minutes;
      final parts = nearestLesson?.bodyData?.date?.split("@");
      return isActivityStartingIn15Minutes
          ? Container(
              width: double.maxFinite,
              color: Colors.white,
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    //text: "Top Dog Fight Club. Бокс",
                    text: nearestLesson?.bodyData?.gym?.name ?? "",
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                  10.verticalSpace,
                  CustomText(
                    text: "Занятие начнётся в ${parts?[1]}",
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                  10.verticalSpace,
                  CustomButton(
                    onPressed: () {
                      context.pushRoute(const QrCodeRoute());
                    },
                    text: "Отсканировать QR код на стойке",
                    height: 40.h,
                    buttonColor: AppColors.blueColor,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ],
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
