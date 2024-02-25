import 'package:activity/application/activity/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyWidget extends ConsumerStatefulWidget {
  final int gymId;
  const MyWidget(this.gymId, {super.key});

  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(activityProvider.notifier)
        // get list of 15 calendar dates from today   ????
        ..getGymInfo(context, gymId: widget.gymId)
        ..getActivityTypes(context, gymId: widget.gymId)
        ..getInfoForType(context, id: widget.gymId)
        ..getAllLessons(context, id: widget.gymId)
        ..getAllPhotos(context, widget.gymId); //

      // next we will get infos about selected activity :

      // get describtion and peculiarities of selected activity
      // get photos of selected activity
      // get lessons from selected activity && (show dates in calendar)
      // get lesssons of selected activity and selected date
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
