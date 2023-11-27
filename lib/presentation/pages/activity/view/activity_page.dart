import 'package:activity/application/activity/activity_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/widget.dart';

@RoutePage()
class ActivityScreen extends ConsumerStatefulWidget {
  final int gymId;
  const ActivityScreen({required this.gymId, super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initstate called");

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        // get info `bout gym
        ref
            .read(activityProvider.notifier)
            .getGymInfo(
              gymId: widget.gymId,
            )
            .then((value) {
          ref
              .read(activityProvider.notifier)
              .getActivitiesList(gymId: widget.gymId)
              .then(
                (value) => ref
                    .read(activityProvider.notifier)
                    .determineDefaultActivity()
                    .then(
                      (value) =>
                          ref.read(activityProvider.notifier).getGymPhotos(
                                ref.watch(activityProvider).selectedActivity,
                                widget.gymId,
                              ),
                    ),
              );

          ref
              .read(activityProvider.notifier)
              .getSchedulesDates(context, id: widget.gymId)
              .then((value) => ref
                  .read(activityProvider.notifier)
                  .getListOf15CalendarDatesFromToday())
              .then(
                (value) => ref
                    .read(activityProvider.notifier)
                    .getListOf15OriginalDatesFromToday(),
              )
              .then((value) => ref
                  .read(activityProvider.notifier)
                  .determineDefaultOriginalDate())
              .then(
                (value) => ref
                    .read(activityProvider.notifier)
                    .determineDefaultFormattedDate(),
              )
              .then(
                (value) => ref.read(activityProvider.notifier).getSchedulesList(
                    ref.watch(activityProvider).selectedOriginalDate),
              );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(activityProvider.notifier);
    final state = ref.watch(activityProvider);
    print("gym >> ${state.gym?.name}");
    print("chips >> ${state.activities?.length}");
    print("selectedactivity >> ${state.selectedActivity}");
    print("list of original dates >> ${state.originalDates}");
    print("available formatted dates ${state.availableFormattedDates}");
    print("15 calendar days from now ${state.listOf15CalendarDaysFromNow}");
    print("selectedOriginalDate ${state.selectedOriginalDate}");
    print("selectedFormatted ${state.selectedFormattedDay}");
    print("list of schedules in in one day >> ${state.listOfSchedules.length}");

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: state.isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TheOneWithImage(
                      state: state,
                      event: event,
                    ),
                    32.verticalSpace,
                    TheOneWithChips(
                      gymId: widget.gymId,
                      state: state,
                      event: event,
                    ),
                    32.verticalSpace,
                    TheOneWithPhotos(
                      event: event,
                      state: state,
                    ),
                    32.verticalSpace,
                    TheOneWithCalendar(
                      gymId: widget.gymId,
                      state: state,
                      event: event,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
