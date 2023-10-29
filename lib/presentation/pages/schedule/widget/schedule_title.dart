import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_bottom_modal.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:activity/presentation/components/ui_button_outlined.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/components/ui_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleTitle extends StatelessWidget {
  ScheduleTitle({super.key});
  String chosenTimeNotificationState = 'за 30 мин';

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
        UiIconButton(
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
                          color: const Color.fromRGBO(245, 249, 255, 1),
                          borderRadius: BorderRadius.circular(16.0)),
                      padding: const EdgeInsets.all(16.0),
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
                                'title': 'За 30 минут',
                                'action': () {
                                  setState(() {
                                    chosenTimeNotificationState = 'за 30 минут';
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
                                Text(chosenTimeNotificationState),
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
        ),
      ],
    );
  }
}
