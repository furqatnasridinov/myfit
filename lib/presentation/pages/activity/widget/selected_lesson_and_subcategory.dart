import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_text.dart';

class SelectedLessonAndSubcategory extends StatelessWidget {
  const SelectedLessonAndSubcategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: SizedBox(
        width: double.maxFinite,
        child: DecoratedBox(decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Consumer(
                builder: (context, ref, child) {
                  final String selectedLesson = ref.watch(activityProvider).selectedActivity ?? "";
                  final String selectedSubcategory = ref.watch(activityProvider).selectedSubCategory?.name ?? "";
                  return Wrap(
                    children: [
                      CustomText(
                        text: selectedLesson,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      10.horizontalSpace,
                      if (selectedSubcategory.isNotEmpty)
                      CustomText(
                        text: "/",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blueText,
                      ),
                      if (selectedSubcategory.isNotEmpty) 10.horizontalSpace,
                      if (selectedSubcategory.isNotEmpty)
                      CustomText(
                        text: selectedSubcategory,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  );
                },
              )
          ),
        ),
      ),
    );
  }
}
