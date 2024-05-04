import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/inter_text.dart';

class RemainingVisits extends StatelessWidget {
  const RemainingVisits({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: double.maxFinite,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: AppColors.greyBorder),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Consumer(builder: (context, ref, child) {
              final gym = ref.watch(activityProvider).gym;
              int? visitRemaining = (gym?.visitPerMonth ?? 0) - (gym?.visitedCount ?? 0);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InterText(
                    text: "Осталось походов в этом месяце: ",
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                  2.horizontalSpace,
                  InterText(
                    text: "$visitRemaining/${gym?.visitPerMonth}",
                    fontSize: 12.sp,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
