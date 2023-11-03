import 'dart:math';

import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/pages/schedule/widget/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleCardMaker extends StatefulWidget {
  final String date;
  final String dayOfWeek;
  final List<ScheduleItemWidget> scheduleItems;

  ScheduleCardMaker({
    super.key,
    required this.date,
    required this.scheduleItems,
    required this.dayOfWeek,
  });

  @override
  State<ScheduleCardMaker> createState() => _ScheduleCardState();
}

bool plusState = false;

class _ScheduleCardState extends State<ScheduleCardMaker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      margin: EdgeInsets.only(bottom: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // row (date and Plus button)
          Row(
            children: [
              CustomText(
                text: "${widget.dayOfWeek} ${widget.date}",
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              _plusButton(),
            ],
          ),
          10.verticalSpace,
          // Отобразите список элементов расписания
          Column(
            children: widget.scheduleItems,
          ),
        ],
      ),
    );
  }

  Widget _plusButton() {
    return UiDropDownMenu(
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
    );
  }
}
