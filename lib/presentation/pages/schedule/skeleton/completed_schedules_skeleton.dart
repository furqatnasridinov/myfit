import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class CompletedSchedulesSkeleton extends StatelessWidget {
  const CompletedSchedulesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(children: [
        SkeletonCard(width: 120.w, isBlue: true),
        const Spacer(),
        SkeletonCard(width: 140.w, height: 40.h, isBlue: true),
      ],),
    );
  }
}