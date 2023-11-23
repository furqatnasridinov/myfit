import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingActivity extends StatelessWidget {
  final ScheduleState state;
  final ScheduleNotifier event;
  const ComingActivity({super.key, required this.state, required this.event});

  @override
  Widget build(BuildContext context) {
    List<String> parts = state.nearestLesson!.bodyData!.date!.split("@");
    final String formattedDay = event.formatDay(parts[0]);
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
                //text: 'через 1ч 16м',
                text: state.whenActivityStarts,
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
                  SizedBox(
                    child: CustomText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text:
                          state.nearestLesson?.bodyData?.description ?? "Empty",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
                    text: "$formattedDay  ${parts[1]} часа",
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      text: state.nearestLesson?.bodyData?.gym?.address ??
                          "Empty",
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
                onTap: () {},
                child: CustomText(
                  text: 'Посмотреть детали',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blueColor,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
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
