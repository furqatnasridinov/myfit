import 'package:activity/presentation/components/header.dart';
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
      appBar: const Header(
        backRoute: '/schedule',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.only(top: 27.0),
        child: Column(
          children: [
            const SelectPeriodOne(),
            32.verticalSpace,
            const ScheduleItemCard(),
          ],
        ),
      ),
    );
  }
}
