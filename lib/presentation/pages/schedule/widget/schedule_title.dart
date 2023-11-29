import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
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
        Row(
          children: [
            InkWell(
              onTap: () {
                context.router.push(NotesRoute(gymName: ""));
              },
              child: Container(
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
                  'assets/svg/edit_icon.svg',
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
            10.horizontalSpace,
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
                                          borderRadius:
                                              BorderRadius.circular(16.r),
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
                                              customOffset: [80.w, 20.w],
                                              width: 100.w,
                                              //height: 20.h,
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
                                          borderRadius:
                                              BorderRadius.circular(16.r),
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
                                                      BorderRadius.circular(
                                                          8.r),
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
                                                            BorderRadius
                                                                .circular(6.r),
                                                        color: AppColors
                                                            .backgroundColor,
                                                      ),
                                                      child: const Icon(
                                                        Icons.schedule_outlined,
                                                        color:
                                                            AppColors.blueColor,
                                                      ),
                                                    ),
                                                    10.horizontalSpace,
                                                    CustomText(
                                                      text:
                                                          "за $chosenTimeNotificationState",
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                const Spacer(),
                                // buttons
                                if (chosenTimeNotificationState != "никогда")
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          height: 40.h,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
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
                                          height: 40.h,
                                          textColor: Colors.white,
                                          buttonColor: AppColors.blueColor,
                                          borderColor: AppColors.blueBorder,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          onPressed: () {
                                            context.popRoute();
                                          },
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
          ],
        ),
      ],
    );
  }
}
