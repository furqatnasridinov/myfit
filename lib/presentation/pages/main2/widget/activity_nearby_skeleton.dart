import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class ActivityNearbySkeleton extends StatelessWidget {
  const ActivityNearbySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonCard(
            width: width - 100,
          ),
          10.verticalSpace,
          SizedBox(
            width: width,
            //height: 300.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.skeletonSecondary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      runSpacing: 10.w,
                      spacing: 10.w,
                      children: [
                        eachActivity(),
                        eachActivity(width: 70),
                        eachActivity(width: 100),
                        eachActivity(width: 90),
                        eachActivity(width: 200),
                      ],
                    ),
                    10.verticalSpace,
                    SkeletonCard(
                      height: 150,
                      width: width,
                      isBlue: true,
                      borderRadius: 16,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget eachActivity({
  double width = 150,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SkeletonCard(isBlue: true),
      5.horizontalSpace,
      SkeletonCard(width: width, isBlue: true),
    ],
  );
}
