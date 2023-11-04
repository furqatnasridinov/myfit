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

    ref
        .read(activityProvider.notifier)
        .getActivitiesList(gymId: widget.gymId)
        .then(
          (value) => ref
              .read(activityProvider.notifier)
              .determineDefaultActivity()
              .then(
                (value) => ref.read(activityProvider.notifier).getGymPhotos(
                      ref.watch(activityProvider).selectedActivity,
                      widget.gymId,
                    ),
              ),
        );

    ref
        .read(activityProvider.notifier)
        .getSchedulesDates(id: 1)
        .then(
          (value) => ref.read(activityProvider.notifier).selectADay(
                ref.watch(activityProvider).availableDates[0],
              ),
        )
        .then(
          (value) => ref
              .read(activityProvider.notifier)
              .setSelectedOriginalDate(
                ref.watch(activityProvider).availableDates[0],
              )
              .then(
                (value) => ref.read(activityProvider.notifier).getSchedulesList(
                    ref.watch(activityProvider).selectedOriginalDate),
              ),
        );
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(activityProvider.notifier).getListOfDates();
        ref.read(activityProvider.notifier).getGymInfo(gymId: widget.gymId);
        //ref.read(gymProvider.notifier).getActivitiesList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(activityProvider.notifier);
    final state = ref.watch(activityProvider);
/*     print("state.activities >> ${state.activities} ");
    print("selected activity ${state.selectedActivity}");
    print("photos >>> ${state.photos}");
     print("state.listOfSchedules${state.listOfSchedules}");
    print("state.scheddules ${state.scheddules}");
    
    print("state.originalDates >> ${state.originalDates}");
    */
/*     print("state.defaultDate ${state.defaultDate}");
    print("availableDates >>> ${state.availableDates}");
    print("state.selectedDay ${state.selectedDay}");
    print("state.selectedOriginalDate ${state.selectedOriginalDate}"); */

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: state.gym?.name == null && state.activities!.isEmpty
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
