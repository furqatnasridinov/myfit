import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class ActivityDescription extends StatelessWidget {
  const ActivityDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final typeDescription = ref.watch(activityProvider).describtionAndPeculiarities?.typeDescription;
      final loading = ref.watch(activityProvider).infoForTypeLoading;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: loading ? [
            32.verticalSpace,
            SkeletonCard(width: 200),
            4.verticalSpace,
            SkeletonCard(width: double.maxFinite, height:  70),
          ] : [
            32.verticalSpace,
            CustomText(
              text: "Описание активности",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            CustomText(
              text: typeDescription ?? "",
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.1,
            ),
          ],
        ),
      );
    });
  }
}
