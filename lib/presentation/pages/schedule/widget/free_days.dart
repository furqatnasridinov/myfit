import 'dart:math';

import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class FreeDays extends StatelessWidget {
  final String dayOfWeek;
  final String date;
  final ScheduleNotifier event;
  final ScheduleState state;
  const FreeDays(
      {super.key,
      required this.dayOfWeek,
      required this.date,
      required this.event,
      required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      margin: EdgeInsets.only(bottom: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "$dayOfWeek $date",
            fontWeight: FontWeight.w600,
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 10.w,
              ),
              InterText(
                text: "На этот день ничего не запланировано",
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              _plusButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _plusButton(BuildContext context) {
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
          'action': () => {
            context.router.push(const MapRoute())
          }
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
          'action': () => {
                context.router.push(ActivityRoute(gymId: 1)),
              }
        },
      ],
      onOpenedAction: () => {event.triggerPlusState()},
      onClosedAction: () => {event.removePlusState()},
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
          angle: state.plusState == true ? (45 * pi / 180) : (0 * pi / 180),
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
