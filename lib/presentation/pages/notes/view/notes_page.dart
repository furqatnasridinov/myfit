import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/pages/notes/widget/notes_header.dart';
import 'package:activity/presentation/pages/notes/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _ScheduleItemScreen();
}

class _ScheduleItemScreen extends State<NotesScreen> {
  bool geoButton = false;
  bool flashButton = false;
  String chosenSchedulesTime = 'сегодня';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: const NotesHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              const SelectPeriodOne(),
              32.verticalSpace,
              const ScheduleItemCard(),
              25.verticalSpace,
              const ScheduleItemCard(),
               25.verticalSpace,
              const ScheduleItemCard(),
               25.verticalSpace,
              const ScheduleItemCard(),
            ],
          ),
        ),
      ),
    );
  }
}
