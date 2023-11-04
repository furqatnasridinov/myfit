import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/dummy_data.dart';
import 'package:activity/presentation/pages/schedule/widget/free_days.dart';
import 'package:activity/presentation/pages/schedule/widget/schedule_card_maker.dart';
import 'package:activity/presentation/pages/schedule/widget/schedule_item.dart';
import 'package:activity/presentation/pages/schedule/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

@RoutePage()
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({
    super.key,
  });

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreen();
}

class _ScheduleScreen extends ConsumerState<ScheduleScreen> {
  final List<String> allDayOfMonth = DummyData().days30;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(scheduleProvider.notifier).getUsersSchedules(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleProvider);
    final event = ref.read(scheduleProvider.notifier);
    /* final experiment = event.durationToTillWhen("14:00", "02:30");
    print("experiment  $experiment"); */
    //print("state.schedulesInMapForm >> ${state.schedulesInMapForm}");

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const ScheduleHeader(),
      body: state.isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverToBoxAdapter(
                      child: ScheduleTitle(),
                    ),
                  ),

                  // body builder
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w)
                        .copyWith(top: 16.h),
                    sliver: SliverList.builder(
                      itemCount: allDayOfMonth.length,
                      itemBuilder: (context, index) {
                        final date = allDayOfMonth[index];
                        final formattedDay = event.formatDay(date);
                        final formattedDayOfWeek = event.determineWeekday(date);
                        if (state.schedulesInMapForm.containsKey(date)) {
                          final scheduleItemsData =
                              state.schedulesInMapForm[date];
                          List<ScheduleItemWidget> scheduleItems =
                              (scheduleItemsData as List).map((itemData) {
                            return ScheduleItemWidget(
                              event: event,
                              state: state,
                              id: itemData['id'],
                              time: itemData['date'],
                              description: itemData['description'],
                              duration: itemData["duration"],
                              address: itemData['gym']['address'],
                            );
                          }).toList();
                          return ScheduleCardMaker(
                            event: event,
                            state: state,
                            dayOfWeek: formattedDayOfWeek,
                            date: formattedDay,
                            scheduleItems: scheduleItems,
                          );
                        } else {
                          return FreeDays(
                            event: event,
                            state: state,
                            dayOfWeek: formattedDayOfWeek,
                            date: formattedDay,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
