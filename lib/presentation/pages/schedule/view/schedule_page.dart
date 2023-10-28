import 'package:activity/presentation/pages/schedule/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../application/schedule/schedule_notifier.dart';
import '../../../../application/schedule/schedule_state.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

@RoutePage()
class ScheduleScreen extends ConsumerStatefulWidget {
  final ScheduleNotifier event;
  final ScheduleState state;
  const ScheduleScreen({required this.event, required this.state, super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreen();
}

class _ScheduleScreen extends ConsumerState<ScheduleScreen> {
  bool settingsModalState = false;
  bool isSearchBarOpened = false;

  TimeOfDay? selectedTime =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  final currenTime = DateTime.now();
  DateTime? selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  appBar: Header(
        event: widget.event,
        state: widget.state,
        backRoute: '/',
      ), */
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // header
              ScheduleHeader(
                event: widget.event,
                state: widget.state,
              ),
              // body
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                margin: const EdgeInsets.only(top: 17.0),
                child: Column(
                  children: [
                    ScheduleTitle(),
                    16.verticalSpace,
                    const SchedulesList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
