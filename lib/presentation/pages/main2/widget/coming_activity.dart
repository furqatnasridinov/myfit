import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingActivity extends StatelessWidget {
  ComingActivity({super.key});

  ScheduleNotifier scheduleNotifier = ScheduleNotifier();
  ScheduleState scheduleState = const ScheduleState();
  @override
  Widget build(BuildContext context) {
    return UiCard(
      cardValue: Column(
        children: [
          Row(
            children: [
              CustomText(
                text: 'Ваше ближайшее событие:',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              CustomText(
                text: 'через 1ч 16м',
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.greyText,
              )
            ],
          ),
          const SizedBox(height: 10),
          Column(children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(245, 249, 255, 1),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                children: [
                  const Icon(
                    Icons.flash_on_outlined,
                    size: 18.0,
                    color: Color.fromRGBO(119, 170, 249, 1),
                  ),
                  7.horizontalSpace,
                  CustomText(
                    text: 'Массаж расслабляющий',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 249, 255, 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.watch,
                    size: 18.r,
                    color: const Color.fromRGBO(119, 170, 249, 1),
                  ),
                  7.horizontalSpace,
                  CustomText(
                    text: '13:30 Сегодня',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 249, 255, 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18.r,
                    color: const Color.fromRGBO(119, 170, 249, 1),
                  ),
                  7.horizontalSpace,
                  Flexible(
                    child: CustomText(
                      text:
                          'Салон красоты “Viva-Vite”.ул. Лёни Ленина, д. 12, БЦ “Big Мук”',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ]),
          10.verticalSpace,
          Row(
            children: [
              InkWell(
                onTap: () {
                  context.router.push(
                    ScheduleRoute(
                      event: scheduleNotifier,
                      state: scheduleState,
                    ),
                  );
                },
                child: CustomText(
                  text: 'Посмотреть детали',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blueColor,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  context.router.push( ActivityRoute(gymId: 1));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    color: const Color.fromRGBO(245, 249, 255, 1),
                    padding: EdgeInsets.all(3.r),
                    child: Icon(
                      Icons.edit_note,
                      color: const Color.fromRGBO(119, 170, 249, 1),
                      size: 18.r,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
