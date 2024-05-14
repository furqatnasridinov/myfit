import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class RamainingVisitsSkeleton extends StatelessWidget {
  const RamainingVisitsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      height: 40.h,
      width: double.infinity,
    );
  }
}
