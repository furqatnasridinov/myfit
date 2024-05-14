import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class PhotoSkeleton extends StatelessWidget {
  const PhotoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.skeletonBg,
      height: 210.h,
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // top part
            Row(
              children: [
                SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.skeletonSecondary,
                    ),
                  ),
                ),
                10.horizontalSpace,
                SkeletonCard(width: 260),
                const Spacer(),
                SkeletonCard(),
              ],
            ),

            // bottom part
            Row(
              children: [
                SkeletonCard(),
                7.horizontalSpace,
                SkeletonCard(width: 310),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
