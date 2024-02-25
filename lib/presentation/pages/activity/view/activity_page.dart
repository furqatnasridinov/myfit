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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(activityProvider.notifier)
          ..getListOf15CalendarDatesFromToday()
          ..getGymInfo(context, gymId: widget.gymId)
          ..getActivityTypes(context, gymId: widget.gymId)
          ..getInfoForType(context, id: widget.gymId)
          ..getAllPhotos(context, widget.gymId)
          ..getAllLessons(context, id: widget.gymId)
              // get infos after the selected activity is set
              .then((value) {
            ref.read(activityProvider.notifier)
              ..getPhotosOfSelectedActivity(
                  ref.watch(activityProvider).selectedActivity!)
              ..getDescribtionAndPeculiarities(
                  ref.watch(activityProvider).selectedActivity!)
              ..getLessonsOfSelectedActivity(
                  ref.watch(activityProvider).selectedActivity!);
          });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(activityProvider.notifier);
    final state = ref.watch(activityProvider);

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
                    Contacts(event: event),
                    32.verticalSpace,
                    TheOneWithChips(
                      gymId: widget.gymId,
                      state: state,
                      event: event,
                    ),
                    32.verticalSpace,
                    const Description(),
                    32.verticalSpace,
                    TheOneWithPhotos(
                      event: event,
                    ),
                    32.verticalSpace,
                    Speciality(),
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
