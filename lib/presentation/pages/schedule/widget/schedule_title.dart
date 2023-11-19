import 'dart:ui';

import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_text.dart';

import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleTitle extends StatelessWidget {
  final ScheduleState state;
  final ScheduleNotifier event;
  ScheduleTitle({super.key, required this.state, required this.event});

  String chosenTimeNotificationState = '30 мин';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: CustomText(
            text: 'Ваше расписание ',
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        const Spacer(),
        Container(
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
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
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
                            // main
                            chosenTimeNotificationState == "никогда"
                                ? Container(
                                    width: double.maxFinite,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: AppColors.backgroundColor,
                                    ),
                                    padding: EdgeInsets.all(16.r),
                                    child: Row(
                                      children: [
                                        CustomText(
                                          text: "Напоминания отключены.",
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        3.horizontalSpace,
                                        UiDropDownMenu(
                                          width: 100.w,
                                          height: 20.h,
                                          dropDownItemsList: [
                                            {
                                              'title': 'за 30 мин',
                                              'action': () {
                                                setState(() {
                                                  chosenTimeNotificationState =
                                                      '30 мин';
                                                });
                                              }
                                            },
                                            {
                                              'title': 'за 1 час',
                                              'action': () {
                                                setState(() {
                                                  chosenTimeNotificationState =
                                                      '1 час';
                                                });
                                              }
                                            },
                                            {
                                              'title': 'за 2 часа',
                                              'action': () {
                                                setState(() {
                                                  chosenTimeNotificationState =
                                                      '2 часа';
                                                });
                                              }
                                            },
                                            {
                                              'title': 'Никогда',
                                              'action': () {
                                                setState(() {
                                                  chosenTimeNotificationState =
                                                      'никогда';
                                                });
                                              }
                                            },
                                          ],
                                          dropDownChild: CustomText(
                                            text: "Включить!",
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.blueColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
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
                                          width: 172.w,
                                          child: CustomText(
                                            text:
                                                "За какое время до занятия присылать пуш-напоминание",
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        UiDropDownMenu(
                                          width: 100.w,
                                          height: 20.h,
                                          dropDownItemsList: [
                                            {
                                              'title': 'за 30 мин',
                                              'action': () {
                                                setState(() {
                                                  chosenTimeNotificationState =
                                                      '30 мин';
                                                });
                                              }
                                            },
                                            {
                                              'title': 'за 1 час',
                                              'action': () {
                                                setState(() {
                                                  chosenTimeNotificationState =
                                                      '1 час';
                                                });
                                              }
                                            },
                                            {
                                              'title': 'за 2 часа',
                                              'action': () {
                                                setState(() {
                                                  chosenTimeNotificationState =
                                                      '2 часа';
                                                });
                                              }
                                            },
                                            {
                                              'title': 'Никогда',
                                              'action': () {
                                                setState(() {
                                                  chosenTimeNotificationState =
                                                      'никогда';
                                                });
                                              }
                                            },
                                          ],
                                          dropDownChild: Container(
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
                                                  text:
                                                      "за $chosenTimeNotificationState",
                                                  fontFeatures: const [
                                                    FontFeature
                                                        .tabularFigures(),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            32.verticalSpace,
                            // buttons
                            if (chosenTimeNotificationState != "никогда")
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      buttonColor: Colors.white,
                                      onPressed: () {
                                        context.popRoute();
                                      },
                                      text: "Отменить",
                                    ),
                                  ),
                                  5.horizontalSpace,
                                  Expanded(
                                    child: CustomButton(
                                      textColor: Colors.white,
                                      buttonColor: AppColors.blueColor,
                                      onPressed: () {},
                                      text: "Сохранить",
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: SvgPicture.asset(
              "assets/svg/tune.svg",
            ),
          ),
        ),
        /*   UiIconButton(
          iconButton: SvgPicture.asset(
            "assets/svg/tune.svg",
          ),
          iconSize: 24.r,
          onPressedAction: () => {
            UiBottomModal.openModal(
                context,
                'Настройки расписания',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: Row(children: [
                        SizedBox(
                          width: 175.w,
                          child: CustomText(
                            text:
                                'За какое время до занятия присылать пуш-напоминание',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                        const Spacer(),
                        // Для реактивности работы с модалками
                        StatefulBuilder(builder: (context, setState) {
                          return UiDropDownMenu(
                            dropDownItemsList: [
                              {
                                'title': 'За 30 мин',
                                'action': () {
                                  setState(() {
                                    chosenTimeNotificationState = 'за 30 мин';
                                  });
                                }
                              },
                              {
                                'title': 'За 1 час',
                                'action': () {
                                  setState(() {
                                    chosenTimeNotificationState = 'за 1 час';
                                  });
                                }
                              },
                              {
                                'title': 'За 2 часа',
                                'action': () {
                                  setState(() {
                                    chosenTimeNotificationState = 'за 2 часа';
                                  });
                                }
                              },
                              {
                                'title': 'Никогда',
                                'action': () {
                                  setState(() {
                                    chosenTimeNotificationState = 'никогда';
                                  });
                                }
                              },
                            ],
                            dropDownChild: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1.w,
                                  color: const Color.fromRGBO(
                                    233,
                                    233,
                                    233,
                                    1,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.only(
                                top: 6.h,
                                bottom: 6.h,
                                left: 8.w,
                                right: 16.w,
                              ),
                              child: Row(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: Container(
                                    color:
                                        const Color.fromRGBO(245, 249, 255, 1),
                                    padding: EdgeInsets.all(5.r),
                                    child: Icon(
                                      Icons.schedule_outlined,
                                      color:
                                          const Color.fromRGBO(62, 134, 245, 1),
                                      size: 18.r,
                                    ),
                                  ),
                                ),
                                10.horizontalSpace,
                                CustomText(
                                  text: chosenTimeNotificationState,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                )
                                // Text(chosenTimeNotificationState),
                              ]),
                            ),
                          );
                        })
                      ]),
                    ),
                    32.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: UiButtonOutlined(
                            btnText: 'Отменить',
                            onPressedAction: () => {
                              Navigator.pop(context),
                            },
                          ),
                        ),
                        5.horizontalSpace,
                        Expanded(
                          child: UiButtonFilled(
                            btnText: 'Сохранить',
                            onPressedAction: () {
                              print('123');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          },
        ), */
      ],
    );
  }
}
