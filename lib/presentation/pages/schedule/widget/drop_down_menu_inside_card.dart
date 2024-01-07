// ignore_for_file: must_be_immutable

import 'package:activity/application/main2/main2_provider.dart';
import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DropDownMenuInsideCard extends StatelessWidget {
  void Function()? onTap;
  int? id;
  ScheduleNotifier? event;
  DateTime? startingTimeInDateTime;
  DropDownMenuInsideCard({
    super.key,
    this.onTap,
    this.id,
    this.event,
    this.startingTimeInDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final main2Event = ref.read(main2Provider.notifier);
        return UiDropDownMenu(
          width: 230.w,
          maxWidth: 255.w,
          height: 45.h,
          customOffset: [-25.0.w, -39.h],
          dropDownItemsList: !DateTime.now()
                  .isAfter(startingTimeInDateTime ?? DateTime.now())
              ? [
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
                          event
                              ?.cancelActivity(id!, context)
                              .then(
                                (value) => event?.getUsersSchedules(context),
                              )
                              .then(
                                (value) => main2Event.getNearestLesson(context),
                              ),
                        }
                  },
                ]
              : [
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
                ],
          dropDownChild: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          //
        );
      },
    );
  }
}
