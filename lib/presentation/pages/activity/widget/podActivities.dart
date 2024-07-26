import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/infrastructure/models/data/subcategory.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_text.dart';



class Podactivities extends StatelessWidget {
  const Podactivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final List<SubCategory> subCategoriessub = ref.watch(activityProvider).subCategories;
        final  SubCategory? selectedActivity = ref.watch(activityProvider).selectedSubCategory;
        final event = ref.read(activityProvider.notifier);
        if (subCategoriessub.isEmpty) {
          return const SizedBox();
        }
        return Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Выбор подгруппы активности",
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.black,
              ),
              10.verticalSpace,
              Wrap(
                runSpacing: 5.h,
                spacing: 5.w,
                children: List.generate(subCategoriessub.length, (index) {
                  final current = subCategoriessub[index];
                  bool isActive = selectedActivity?.id == current.id;
                  return GestureDetector(
                    onTap: () async {
                      event.changeSelectedSubCategory(current);
                      /* await event.removeSelectedCalendarDay();
                      event
                        ..setSingleSelectedActivity(current)
                        ..getDescribtionAndPeculiarities(current)
                        ..getPhotosOfSelectedActivity(current)
                        ..getLessonsOfSelectedActivity(current, true); */
                    },
                    child: AnimationButtonEffect(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                              color: isActive
                                  ? Colors.transparent
                                  : AppColors.blueBorder),
                          color: isActive ? AppColors.blueColor : Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 5.h,
                          ),
                          child: CustomText(
                            text: current.name ?? "",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: isActive ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}