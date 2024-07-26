import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:myfit/infrastructure/models/data/notification.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'widget.dart';

class NotificationBottomSheet extends StatelessWidget {
  final void Function()? onNavigate;
  final List<NotificationModel> list ;
   const NotificationBottomSheet({super.key, required this.list, this.onNavigate});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Wrap(
        spacing: 32.h,
        children: [
          // grey line
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 73.w,
              height: 3.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.greyBorder,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),

          32.verticalSpace,

          // icon and text
          Row(
            children: [
              // back icon
              GestureDetector(
                onTap: () {
                  context.popRoute();
                },
                child: SizedBox(
                  height: 40.h,
                  width: 40.w,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.greyBorder,
                        width: 1.w,
                      ),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/svg/back_icon.svg",
                        width: 5.w,
                        height: 10.h,
                      ),
                    ),
                  ),
                ),
              ),
              10.horizontalSpace,
              // title
              CustomText(
                text: "Новые уведомления",
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),

          32.verticalSpace,
          // list of notifications
          if(list.isNotEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 500.h,
            ),
            child: GroupedListView<NotificationModel, String>(
              shrinkWrap: true,
              elements: list,
              order: GroupedListOrder.DESC,
              groupBy: (element) => element.date.toString().substring(0, 10),
              groupSeparatorBuilder: (String groupByValue) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: CustomText(
                  text: AppHelpers.getFormattedDay2(groupByValue),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              itemBuilder: (context, NotificationModel element) => buildGroupList2(element),
              itemComparator: (item1, item2) => item1.date.compareTo(item2.date),
              stickyHeaderBackgroundColor: Colors.white,
              useStickyGroupSeparators: true,
              floatingHeader: false,
            ),
          ),
          if(list.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CustomText(
              text: "Нет новых уведомлений",
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          32.verticalSpace,
          // button
          CustomButton(
            onPressed: onNavigate,
            text: "Посмотреть все уведомления",
            buttonColor: AppColors.blueColor,
            textColor: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 40.h,
          ),
        ],
      ),
    );
  }
}

Widget buildGroupList2(NotificationModel notification) {
  if (notification.type == NotificationType.lessonCompleted) {
    return LessonCompleted(
      lessonType: notification.lessonType,
      unread: !notification.iSread,
      gymName: notification.gymName,
      gymId: notification.gymId,
      grade: notification.grade,
      lessonDescription: notification.lessonDescription,
      gradeId: notification.rateId,
      comment: notification.commentContent,
      time: AppHelpers.getFormattedTime(notification.date),
      batteryIcon: AppHelpers().getBatteryIcon(
          notification.visitedCount ?? 0, notification.visitPerMonth ?? 0),
    );
  }
  if (notification.type == NotificationType.lessonConfirmed) {
    return LessonConfirmed(
      lessonType: notification.lessonType,
      unread: !notification.iSread,
      description: notification.description,
      gymName: notification.gymName,
      gymId: notification.gymId,
      time: AppHelpers.getFormattedTime(notification.date),
      batteryIcon: AppHelpers().getBatteryIcon(
          notification.visitedCount ?? 0, notification.visitPerMonth ?? 0),
    );
  }
  if (notification.type == NotificationType.lessonCancelled) {
    return LessonCancelled(
      lessonType: notification.lessonType,
      unread: !notification.iSread,
      gymName: notification.gymName,
      gymId: notification.gymId,
      lessonStartDate: notification.lessonStartDate,
      reason: notification.reason ?? "",
      time: AppHelpers.getFormattedTime(notification.date),
      batteryIcon: AppHelpers().getBatteryIcon(
          notification.visitedCount ?? 0, notification.visitPerMonth ?? 0),
    );
  }
  if (notification.type == NotificationType.lessonChanged) {
    return LessonChanged(
      lessonType: notification.lessonType,
      unread: !notification.iSread,
      gymName: notification.gymName,
      gymId: notification.gymId,
      lessonStartDate: notification.lessonStartDate,
      updates: notification.updates,
      time: AppHelpers.getFormattedTime(notification.date),
      batteryIcon: AppHelpers().getBatteryIcon(
          notification.visitedCount ?? 0, notification.visitPerMonth ?? 0),
    );
  }
  if (notification.type == NotificationType.visitsCountIsGettingLowOrEnded) {
    return VisitsCountEnding(
      lessonType: notification.lessonType,
      unread: !notification.iSread,
      title: notification.title,
      description: notification.description,
      gymName: notification.gymName,
      gymId: notification.gymId,
      time: AppHelpers.getFormattedTime(notification.date),
      batteryIcon: AppHelpers().getBatteryIcon(
          notification.visitedCount ?? 0, notification.visitPerMonth ?? 0),
    );
  }
  if (notification.type == NotificationType.lessonStartsWithin15minutes) {
    return LessonStartsWithin15Minutes(
      lessonType: notification.lessonType,
      unread: !notification.iSread,
      gymName: notification.gymName,
      gymId: notification.gymId,
      time: AppHelpers.getFormattedTime(notification.date),
      batteryIcon: AppHelpers().getBatteryIcon(
          notification.visitedCount ?? 0, notification.visitPerMonth ?? 0),
    );
  }
  if (notification.type == NotificationType.system) {
    return SystemNotification(
      unread: !notification.iSread,
      title: notification.title,
      gymId: notification.gymId,
      gymName: notification.gymName,
      lessonType: notification.lessonType,
      description: notification.description,
      time: AppHelpers.getFormattedTime(notification.date),
      batteryIcon: AppHelpers().getBatteryIcon(
          notification.visitedCount ?? 0, notification.visitPerMonth ?? 0),
    );
  }
  return const SizedBox();
}
