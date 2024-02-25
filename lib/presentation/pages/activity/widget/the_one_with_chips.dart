import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/components.dart';

class TheOneWithChips extends StatelessWidget {
  final ActivityState state;
  final ActivityNotifier event;
  final int gymId;

  const TheOneWithChips({
    super.key,
    required this.state,
    required this.event,
    required this.gymId,
  });

  @override
  Widget build(BuildContext context) {
    return state.activityTypes!.isEmpty
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Выбор активности",
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
                10.verticalSpace,
                Wrap(
                  runSpacing: 5.h,
                  spacing: 5.w,
                  children:
                      List.generate(state.activityTypes?.length ?? 0, (index) {
                    final current = state.activityTypes?[index];
                    bool isActive = current == state.selectedActivity;
                    return InkWell(
                      onTap: () async {
                        await event.removeSelectedCalendarDay();
                        event
                          ..setSingleSelectedActivity(current)
                          ..getDescribtionAndPeculiarities(current ?? "")
                          ..getPhotosOfSelectedActivity(current ?? "")
                          ..getLessonsOfSelectedActivity(current ?? "");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: isActive
                                ? Colors.transparent
                                : AppColors.blueBorder,
                          ),
                          color: isActive ? AppColors.blueColor : Colors.white,
                        ),
                        child: CustomText(
                          text: current ?? "",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: isActive ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
  }
}
