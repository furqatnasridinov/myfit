import 'package:activity/application/settings/settings_provider.dart';
import 'package:activity/infrastructure/local_notifications/notification_service.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceholderComingActivity extends ConsumerWidget {
  const PlaceholderComingActivity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.read(settingsProvider.notifier);
    return Container(
      height: 56.h,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color.fromRGBO(109, 150, 212, 1),
            offset: Offset(0, 15),
            blurRadius: 18,
            spreadRadius: -15,
          ),
        ],
      ),
      child: CustomButton(
        buttonColor: AppColors.blueColor,
        textColor: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        onPressed: () {
          // event.showDefaultNotification();
          /* event.showScheduledNotification(
            time: DateTime.parse("2024-02-13 10:00:00"),
          ); */
          //NotificationService().cancelNotification();
          context.router.push(MapRoute(showOnlyKnown: false));
        },
        text: "Найти себе занятие",
      ),
    );
  }
}
