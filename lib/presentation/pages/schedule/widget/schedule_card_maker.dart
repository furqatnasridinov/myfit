import 'dart:math';

import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/pages/schedule/widget/schedule_item.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleCardMaker extends StatelessWidget {
  final String date;
  final String dayOfWeek;
  final List<ScheduleItemWidget> scheduleItems;
  final ScheduleNotifier event;
  final ScheduleState state;

  const ScheduleCardMaker({
    super.key,
    required this.date,
    required this.scheduleItems,
    required this.dayOfWeek,
    required this.event,
    required this.state,
  });

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
                text: "$dayOfWeek $date",
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              _plusButton(context),
            ],
          ),
          10.verticalSpace,
          // list
          Column(
            children: scheduleItems,
          ),
        ],
      ),
    );
  }

  Widget _plusButton(BuildContext context) {
    return UiDropDownMenu(
      width: double.maxFinite,
      maxWidth: 255.w,
      customOffset: [-45.0.w, -40.0.h],
      dropDownItemsList: LocalStorage.getKnownActivities().isNotEmpty
          ? [
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
                'action': () =>
                    {context.router.push(MapRoute(showOnlyKnown: false))}
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
                      context.router.push(MapRoute(showOnlyKnown: true)),
                    }
              }
            ]
          : [
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
                'action': () =>
                    {context.router.push(MapRoute(showOnlyKnown: false))}
              }
            ],
      onOpenedAction: () => {event.triggerPlusState()},
      onClosedAction: () => {event.removePlusState()},
      dropDownChild: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              width: 1.w,
              color: AppColors.blueColor,
            ),
            color: AppColors.blueColor),
        //padding: EdgeInsets.all(11.r),
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
