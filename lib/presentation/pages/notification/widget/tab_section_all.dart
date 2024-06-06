import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:myfit/application/notification/notification_provider.dart';
import 'package:myfit/infrastructure/models/data/notification.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'widget.dart';

class TabSectionAll extends ConsumerWidget {
  const TabSectionAll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showOnlyNew = ref.watch(notificationProvider).showNewOnly;
    final list = showOnlyNew
        ? ref.watch(notificationProvider).onlyNewNotifications
        : ref.watch(notificationProvider).allNotifications;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h),
        child: Column(
          children: [
            const SectionWithSwitch(),
            if (list.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 150.h),
                child: Center(
                  child: CustomText(
                    text: "У вас нет непрочитанных уведомлений",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Expanded(
              child: GroupedListView<NotificationModel, String>(
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
                itemBuilder: (context, NotificationModel element) => buildGroupList(element),
                itemComparator: (item1, item2) => item1.date.compareTo(item2.date),
                stickyHeaderBackgroundColor: AppColors.backgroundColor,
                useStickyGroupSeparators: true,
                floatingHeader: false,
              ),
            ),
          ],
        ));
  }
}

Widget buildGroupList(NotificationModel notification) {
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
  return const SizedBox();
}
