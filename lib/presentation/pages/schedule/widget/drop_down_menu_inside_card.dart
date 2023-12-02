// ignore_for_file: must_be_immutable

import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DropDownMenuInsideCard extends StatelessWidget {
  void Function()? onTap;
  int? id;
  ScheduleNotifier? event;
  DropDownMenuInsideCard({
    super.key,
    this.onTap,
    this.id,
    this.event,
  });
  TimeOfDay? selectedTime =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  DateTime? selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return UiDropDownMenu(
      width: 230.w,
      height: 45.h,
      customOffset: [-25.0.w, -39.h],
      dropDownItemsList: [
        {
          'title': 'Открыть заметки',
          'icon': SvgPicture.asset(
            'assets/svg/copy.svg',
            colorFilter: const ColorFilter.mode(
              Color.fromRGBO(62, 134, 245, 1),
              BlendMode.srcIn,
            ),
            height: 18.h,
            width: 18.w,
          ),
          'action': onTap,
        },
        /* {
          'title': 'Продублировать на другую дату',
          'icon': SvgPicture.asset(
            'assets/svg/notes.svg',
            colorFilter: const ColorFilter.mode(
              Color.fromRGBO(62, 134, 245, 1),
              BlendMode.srcIn,
            ),
            height: 18.h,
            width: 18.w,
          ),
          'action': () => {
                Future.delayed(Duration.zero, () {
                  UiBottomModal.openModal(
                    context,
                    'Дублирование записи',
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              width: 1.w,
                              color: const Color.fromRGBO(
                                233,
                                233,
                                233,
                                1,
                              ),
                            ),
                          ),
                          child: Column(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InterText(
                                text: 'Тренажёрный зал. Занятие с тренером',
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                              ),
                            ),
                            12.verticalSpace,
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.watch_later_outlined,
                                      color: const Color.fromRGBO(
                                        119,
                                        170,
                                        249,
                                        1,
                                      ),
                                      size: 16.r,
                                    ),
                                    6.horizontalSpace,
                                    InterText(
                                      text: '1,5 часа',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.sp,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: const Color.fromRGBO(
                                      119,
                                      170,
                                      249,
                                      1,
                                    ),
                                    size: 16.r,
                                  ),
                                  6.horizontalSpace,
                                  InterText(
                                    text: 'Viva-vite',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp,
                                  )
                                ])
                              ],
                            ),
                          ]),
                        ),
                        16.verticalSpace,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: 'Выберите дату и время',
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                        ),
                        16.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return UiActionButtonOutlined(
                                      title: selectedDate
                                          .toString()
                                          .substring(0, 10),
                                      btnLeadingIcon:
                                          Icons.calendar_month_outlined,
                                      onTapAction: () async {
                                        final DateTime? date =
                                            await UiDatePicker.openDatePicker(
                                          context,
                                          selectedDate,
                                        );
                                        setState(() {
                                          selectedDate = date;
                                        });
                                      });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Expanded(child: StatefulBuilder(
                              builder: (context, setState) {
                                return UiActionButtonOutlined(
                                  title: selectedTime!.to24hours(),
                                  btnLeadingIcon: Icons.schedule,
                                  onTapAction: () async {
                                    final TimeOfDay? time =
                                        await UiTimePicker.openTimePicker(
                                            context, selectedTime);
                                    setState(() {
                                      selectedTime = time;
                                    });
                                  },
                                );
                              },
                            )),
                          ],
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          children: [
                            Expanded(
                              child: UiButtonOutlined(
                                btnText: 'Отменить',
                                onPressedAction: () => {Navigator.pop(context)},
                              ),
                            ),
                            5.horizontalSpace,
                            Expanded(
                              child: UiButtonFilled(
                                btnText: 'Добавить запись',
                                onPressedAction: () {
                                  print('123');
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })
              }
        }, */
        {
          'title': 'Отменить запись',
          'icon': SvgPicture.asset(
            'assets/svg/close.svg',
            colorFilter: const ColorFilter.mode(
                Color.fromRGBO(255, 61, 0, 1), BlendMode.srcIn),
            height: 18.h,
            width: 18.w,
          ),
          'action': () => {
                event?.cancelActivity(id!, context).then(
                      (value) => event?.getUsersSchedules(context),
                    ),
              }
        },
      ],
      dropDownChild: const Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      //
    );
  }
}
