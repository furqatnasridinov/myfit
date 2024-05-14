import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class LessonsSkeleton extends StatelessWidget {
  const LessonsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return lessonSkeleton();
          },
        ));
  }
}

Widget lessonSkeleton() {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h),
    width: double.infinity,
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
        color: AppColors.skeletonSecondary,
        borderRadius: BorderRadius.circular(16.r)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SkeletonCard(isBlue: true, width: 100.w, height: 20),
            50.horizontalSpace,
            Expanded(child: SkeletonCard(isBlue: true, height: 20))
          ],
        ),
        10.verticalSpace,
        SkeletonCard(isBlue: true, width: double.infinity, height: 14),
        2.verticalSpace,
        SkeletonCard(isBlue: true, width: 180, height: 14),
        10.verticalSpace,
        SkeletonCard(isBlue: true, width: 180, height: 20),
      ],
    ),
  );
}
