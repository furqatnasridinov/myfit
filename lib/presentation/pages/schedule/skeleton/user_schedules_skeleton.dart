import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class UserSchedulesSkeleton extends StatelessWidget {
  const UserSchedulesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h),
      sliver: SliverList.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          if (index % 3 == 0 && index != 0) {
            return dayWithLesson();
          }else{
            return emptyDay();
          }
        },
      ),
    );
  }
}


Widget emptyDay(){
  return Padding(
    padding: EdgeInsets.only(bottom: 30.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      SkeletonCard(width: 150.w, isBlue: true),
      10.verticalSpace,
      Row(children: [
        10.horizontalSpace,
        SkeletonCard(width: 250.w, height: 15.h, isBlue: true),
        const Spacer(),
        SkeletonCard(width: 40.w, height: 40.h, isBlue: true)
      ],),
    ],),
  );
}

Widget dayWithLesson(){
  return Padding(
    padding: EdgeInsets.only(bottom: 30.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          SkeletonCard(width: 210.w, isBlue: true),
          const Spacer(),
          SkeletonCard(width: 40.w, height: 40.h, isBlue: true)
        ],),
        10.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              SkeletonCard(width: 35.w, height: 15.h, isBlue: true),
              5.verticalSpace,
              SkeletonCard(width: 16.w, height: 16.h, isBlue: true),
              5.verticalSpace,
              SkeletonCard(width: 1.w, height: 80.h, isBlue: true)
            ],),
              16.horizontalSpace,
              Expanded(child: SkeletonCard(height: 125.h, isBlue: true)),
          ],
        ),
    ],),
  );
}