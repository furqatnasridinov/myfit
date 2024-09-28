import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class ScannerButtons extends ConsumerWidget {
  const ScannerButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool loading = ref.watch(membershipProvider).getAllMembershipsLoading;
    if (loading) {
      return _skeleton();
    }
    return CustomCard(
      child: Row(
        children: [
          AnimationButtonEffect(
            child: SizedBox(
              width: 40.w,
              height: 40.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.blueBorder),
                ),
                child: Center(
                  child: SvgPicture.asset("assets/svg/scan.svg"),
                ),
              ),
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: CustomButton(
              onPressed: () {},
              height: 40.h,
              text: "Сканировать QR код на входе",
              fontSize: 14.sp,
              buttonColor: AppColors.blueColor,
              borderColor: AppColors.blueBorder,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

Widget _skeleton(){
  return SizedBox(
    width: double.maxFinite,
    height: 82.h,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.skeletonBg,
        borderRadius: BorderRadius.circular(16.r)
      ),
      child: Padding(
        padding:  EdgeInsets.all(16.r),
        child: Row(
            children: [
              SkeletonCard(width: 40, height: 40),
              16.horizontalSpace,
              Expanded(child: SkeletonCard(height: 40))
            ],
          ),
      ),
    ),
  );
}