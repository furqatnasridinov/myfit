import 'dart:convert';
import 'dart:math';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/header.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_action_button_outlined.dart';
import 'package:activity/presentation/components/ui_bottom_modal.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:activity/presentation/components/ui_button_outlined.dart';
import 'package:activity/presentation/components/ui_date_picker.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/components/ui_icon_button.dart';
import 'package:activity/presentation/components/ui_time_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreen();
}

class _ScheduleScreen extends State<ScheduleScreen> {
  bool plusState = false;
  bool settingsModalState = false;

  String chosenTimeNotificationState = 'за 30 мин';
  TimeOfDay? selectedTime =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  final currenTime = DateTime.now();
  DateTime? selectedDate = DateTime.now();

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http
        .get(Uri.parse('http://94.241.143.241:8080/api/schedule/search'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Ошибка при загрузке данных');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(
          backRoute: '/',
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(top: 17.0),
          child: SingleChildScrollView(
            child: Column(children: [
              _scheduleTitle(),
              const SizedBox(height: 16.0),
              _scheduleList('312', context)
            ]),
          ),
        ));
  }

  _scheduleTitle() {
    return Row(
      children: [
        CustomText(
          text: 'Ваше расписание ',
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
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

// print(DateTime.parse('2023-09-10 19:15:10.824'));
  Widget _scheduleList(String text, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              text: 'Понедельник, 28 августа',
              fontWeight: FontWeight.w600,
            ),
            const Spacer(),
            UiDropDownMenu(
              customOffset: const [-50.0, -40.0],
              dropDownItemsList: [
                {
                  'title': 'Найти что то новое',
                  'icon': SvgPicture.asset(
                    "assets/svg/search.svg",
                    colorFilter: const ColorFilter.mode(
                      Color.fromRGBO(62, 134, 245, 1),
                      BlendMode.srcIn,
                    ),
                    height: 18.h,
                    width: 18.w,
                  ),
                  'action': () => {}
                },
                {
                  'title': 'Выбрать из уже знакомых занятий',
                  'icon': SvgPicture.asset(
                    "assets/svg/copy.svg",
                    colorFilter: const ColorFilter.mode(
                      Color.fromRGBO(62, 134, 245, 1),
                      BlendMode.srcIn,
                    ),
                    height: 18.h,
                    width: 18.w,
                  ),
                  'action': () => {}
                },
              ],
              onOpenedAction: () => {
                setState(() {
                  plusState = true;
                }),
              },
              onClosedAction: () => {
                setState(() {
                  plusState = false;
                }),
              },
              dropDownChild: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    width: 1.w,
                    color: const Color.fromRGBO(89, 154, 254, 1),
                  ),
                  color: const Color.fromRGBO(119, 170, 249, 1),
                ),
                padding: EdgeInsets.all(11.r),
                child: Transform.rotate(
                  angle: plusState == true ? (45 * pi / 180) : (0 * pi / 180),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18.r,
                  ),
                ),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        FutureBuilder<Map<String, dynamic>>(
            future: fetchData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                const Text('Error');
              }
              if (snapshot.hasData) {
                final Map scheduleList = snapshot.data['object'];
                print(snapshot.data['object']);
                return Column(children: [
                  for (var scheduleDay in scheduleList.values)
                    for (var scheduleMark in scheduleDay)
                      _scheduleCard(
                          scheduleMark['description'].toString(),
                          scheduleMark['place'].toString(),
                          scheduleMark['date'].toString(),
                          context),
                ]);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })
      ],
    );
  }

  Widget _scheduleCard(
      String description, String location, String time, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              time.substring(time.length - 5),
              //style: MyFitAppFonts.body2(MyFitAppColors.txtBlack),
            ),
            7.verticalSpace,
            const Icon(
              Icons.watch_later_outlined,
              color: Color.fromRGBO(119, 170, 249, 1),
              size: 20.0,
            ),
            7.verticalSpace,
            const SizedBox(
              height: 33.0,
              child: VerticalDivider(
                color: Color.fromRGBO(119, 170, 249, 1),
              ),
            ),
          ],
        ),
        20.horizontalSpace,
        Expanded(
          child: Card(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color.fromRGBO(233, 233, 233, 1)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                dense: true,
                title: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 218.0,
                            child: InterText(
                              text: description,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                        UiDropDownMenu(
                          customOffset: const [-25.0, -15.0],
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
                              'action': () => {print('123')}
                            },
                            {
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
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: InterText(
                                                    text:
                                                        'Тренажёрный зал. Занятие с тренером',
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
                                                          Icons
                                                              .watch_later_outlined,
                                                          color: const Color
                                                              .fromRGBO(
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
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 13.sp,
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Row(children: [
                                                      Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color: const Color
                                                            .fromRGBO(
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
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                                    builder:
                                                        (context, setState) {
                                                      return UiActionButtonOutlined(
                                                          title: selectedDate
                                                              .toString()
                                                              .substring(0, 10),
                                                          btnLeadingIcon: Icons
                                                              .calendar_month_outlined,
                                                          onTapAction:
                                                              () async {
                                                            final DateTime?
                                                                date =
                                                                await UiDatePicker
                                                                    .openDatePicker(
                                                                        context,
                                                                        selectedDate);
                                                            setState(() {
                                                              selectedDate =
                                                                  date;
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
                                                      title: selectedTime!
                                                          .to24hours(),
                                                      btnLeadingIcon:
                                                          Icons.schedule,
                                                      onTapAction: () async {
                                                        final TimeOfDay? time =
                                                            await UiTimePicker
                                                                .openTimePicker(
                                                                    context,
                                                                    selectedTime);
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
                                                    onPressedAction: () => {
                                                      Navigator.pop(context)
                                                    },
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
                            },
                            {
                              'title': 'Отменить запись',
                              'icon': SvgPicture.asset(
                                'assets/svg/close.svg',
                                colorFilter: const ColorFilter.mode(
                                    Color.fromRGBO(255, 61, 0, 1),
                                    BlendMode.srcIn),
                                height: 18.h,
                                width: 18.w,
                              ),
                              'action': () => {}
                            },
                          ],
                          dropDownChild: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          //
                        ),
                      ],
                    )),
                subtitle: Row(
                  children: [
                    Row(children: [
                      Icon(
                        Icons.watch_later_outlined,
                        color: const Color.fromRGBO(119, 170, 249, 1),
                        size: 16.r,
                      ),
                      6.horizontalSpace,
                      InterText(
                        text: '1,5 часа',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ]),
                    const Spacer(),
                    Row(children: [
                       Icon(
                        Icons.location_on_outlined,
                        color: const Color.fromRGBO(119, 170, 249, 1),
                        size: 16.r,
                      ),
                      6.horizontalSpace,
                      Text(location)
                    ])
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
