import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class GymDescription extends StatelessWidget {
  const GymDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final loading = ref.watch(activityProvider).isGymLoading;
        return Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: loading ? [
              SkeletonCard(width: 180),
              5.verticalSpace,
              SkeletonCard(width: double.infinity, height: 70),
            ] :  [
              CustomText(
                text: "Описание",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              5.verticalSpace,
              InterText(
                text: ref.watch(activityProvider).gym?.description ?? "",
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              )
            ],
          ),
        );
      },
    );
  }
}
