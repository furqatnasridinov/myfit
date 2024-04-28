import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ScheduleTitle extends StatelessWidget {
  const ScheduleTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          text: 'Ваше расписание ',
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
        const Spacer(),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                context.router.push(NotesRoute(gymName: ""));
              },
              child: AnimationButtonEffect(
                child: SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.greyBorder,
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/edit_icon.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return Consumer(builder: (context, ref, child) {
                      final reminderTime =
                          ref.watch(settingsProvider).reminderTime;
                      final isReminderDisabled =
                          ref.watch(settingsProvider).isReminderDisabled;
                      final event = ref.read(settingsProvider.notifier);
                      debugPrint("Reminder time $reminderTime");
                      debugPrint(
                          "Reminder time from local storage ${LocalStorage.getReminderTime()}");
                      debugPrint(
                          "isReminderDisabled ${LocalStorage.isReminderDisabled()}");
                      return Container(
                        height: 270.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                          ),
                        ),
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Center(
                              child: SizedBox(
                                width: 70.w,
                                height: 3.h,
                                child: Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 3.h,
                                ),
                              ),
                            ),
                            32.verticalSpace,
                            // text
                            CustomText(
                              text: "Настройки расписания",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            16.verticalSpace,
                            Container(
                              height: isReminderDisabled ? 50.h : null,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: AppColors.backgroundColor,
                              ),
                              padding: EdgeInsets.all(16.r),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: isReminderDisabled ? null : 172.w,
                                    child: CustomText(
                                      text: isReminderDisabled
                                          ? "Напоминания отключены."
                                          : "За какое время до занятия присылать пуш-напоминание",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  3.verticalSpace,
                                  UiDropDownMenu(
                                    width: 100.w,
                                    height: 20.h,
                                    dropDownItemsList: [
                                      {
                                        'title': 'за 30 мин',
                                        'action': () {
                                          event.setNotificationTime("30");
                                        }
                                      },
                                      {
                                        'title': 'за 1 час',
                                        'action': () {
                                          event.setNotificationTime("1");
                                        }
                                      },
                                      {
                                        'title': 'за 2 часа',
                                        'action': () {
                                          event.setNotificationTime("2");
                                        }
                                      },
                                      {
                                        'title': 'Никогда',
                                        'action': () {
                                          event.disableReminder();
                                        }
                                      },
                                    ],
                                    dropDownChild: isReminderDisabled
                                        ? CustomText(
                                            text: "Включить!",
                                            color: AppColors.blueColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: AppColors.greyBorder,
                                                width: 1.w,
                                              ),
                                              color: Colors.white,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 10.h,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 28.w,
                                                  height: 28.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.r),
                                                    color: AppColors
                                                        .backgroundColor,
                                                  ),
                                                  child: const Icon(
                                                    Icons.schedule_outlined,
                                                    color: AppColors.blueColor,
                                                  ),
                                                ),
                                                10.horizontalSpace,
                                                CustomText(
                                                  text: reminderTime == "30"
                                                      ? "за 30 мин"
                                                      : "за $reminderTime часа",
                                                )
                                              ],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // button
                            CustomButton(
                              height: 40.h,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              buttonColor: AppColors.blueColor,
                              textColor: Colors.white,
                              onPressed: () {
                                context.popRoute();
                              },
                              text: "Вернуться к расписаниям",
                            ),
                          ],
                        ),
                      );
                    });
                  },
                );
              },
              child: AnimationButtonEffect(
                child: SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.greyBorder,
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                  "assets/svg/icon_filter.svg",
                  fit: BoxFit.scaleDown,
                ),
                    ),
                  ),
                ),
              ),
              
              /* Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.greyBorder,
                    width: 1.w,
                  ),
                ),
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(
                  "assets/svg/icon_filter.svg",
                  fit: BoxFit.scaleDown,
                ),
              ), */
            ),
          ],
        ),
      ],
    );
  }
}
