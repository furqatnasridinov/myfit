import 'package:activity/application/activity/activity_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../widget/widget.dart';

@RoutePage()
class ActivityScreen extends ConsumerStatefulWidget {
  final int gymId;
  const ActivityScreen({required this.gymId, super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityScreen> {
  late final WebSocketChannel channel;
  late final WebSocketChannel channel2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(activityProvider.notifier)
          ..getListOf15CalendarDatesFromToday()
          ..getGymInfo(context, gymId: widget.gymId)
          ..getActivityTypes(context,
              gymId: widget.gymId) // and make first item as active
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
                  ref.watch(activityProvider).selectedActivity!, true);

            // web socket for updating lesson states
/*             channel = IOWebSocketChannel.connect(
                Uri.parse("ws://77.222.53.122:8080/appSchedulePanel/${LocalStorage.getUserId()}"),
                headers: {'Authorization': 'Bearer ${LocalStorage.getToken()}'});
                ref.read(activityProvider.notifier).handleWebSocket(channel, context); */
            
            // web socket for gettiing new lessons if they were added when the user is on the page
            channel2 = IOWebSocketChannel.connect(
                Uri.parse("ws://77.222.53.122:8080/appGymPanel/${widget.gymId}"),
                headers: {'Authorization': 'Bearer ${LocalStorage.getToken()}'});
                ref.read(activityProvider.notifier).handleWebSocket2(channel2, context);
          });
      },
    );
  }

  @override
  void dispose() {
    //channel.sink.close();
    channel2.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(activityProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TheOneWithImage(),
              32.verticalSpace,
              Contacts(event: event),
              32.verticalSpace,
              TheOneWithChips(
                gymId: widget.gymId,
              ),
              const Description(),
              TheOneWithPhotos(
                event: event,
              ),
              const Speciality(),
              32.verticalSpace,
              TheOneWithCalendar(
                event: event,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
