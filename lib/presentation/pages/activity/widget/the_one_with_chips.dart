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
/*   void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //widget.event.determineDefaultActivity();
      widget.event.getGymPhotos(widget.state.selectedActivity);
    });
  } */

  @override
  Widget build(BuildContext context) {
    return state.activities!.isEmpty
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
                  runSpacing: 5,
                  spacing: 5.w,
                  children: List.generate(
                    state.activities!.length,
                    (index) {
                      final activity = state.activities![index];
                      final isSelected = activity == state.selectedActivity;
                      return InkWell(
                        onTap: () {
                          //widget.event.getGymPhotos(activity,widget.gymId);
                        },
                        child: ChoiceChip(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 5.h),
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                            side: const BorderSide(color: AppColors.blueColor),
                          ),
                          labelPadding: EdgeInsets.symmetric(
                            vertical: 1.h,
                            horizontal: 12.w,
                          ),
                          selectedColor: const Color.fromRGBO(119, 170, 249, 1),
                          backgroundColor: Colors.white,
                          selected: isSelected,
                          onSelected: (selected)  {
                            if (selected) {
                              event.setSingleSelectedActivity(activity);
                              event.getGymPhotos(activity, gymId);
                              event
                                  .getSchedulesDates(context, id: gymId)
                                  .then((value) async {
                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                              }).then(
                                (value) => event
                                    .determineDefaultOriginalDate()
                                    .then((value) =>
                                        event.determineDefaultFormattedDate())
                                    .then((value) async {
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
                                }).then(
                                  (value) => event.getSchedulesList(
                                    state.selectedOriginalDate,
                                  ),
                                ),
                              );
                            }
                          },
                          label: CustomText(
                            text: activity,
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
