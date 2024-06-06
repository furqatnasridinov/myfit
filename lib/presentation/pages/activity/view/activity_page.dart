// ignore_for_file: must_be_immutable
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/pages/activity/widget/the_one_with_lessons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../widget/widget.dart';

@RoutePage()
class ActivityScreen extends ConsumerStatefulWidget {
  final int gymId;
  bool? isFromMap = false;
  ActivityScreen({super.key, this.isFromMap = false, required this.gymId});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityScreen> {
  late final WebSocketChannel channel;
  late final WebSocketChannel channel2;
  late RefreshController refreshController = RefreshController();
  ScrollController scrollController = ScrollController();
  final calendarSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        // прокрутка
        if (ref.watch(activityProvider).isFromSearch) {
          scrollToCalendar();
        }
        ref.read(activityProvider.notifier)
          ..getListOf15CalendarDatesFromToday()
          ..getGymInfo(context, true, gymId: widget.gymId)
          ..getActivityTypes(
              context, true, ref.watch(mapProvider).selectedLessonTypeFromMap,
              isFromMap: widget.isFromMap ?? false,
              gymId: widget.gymId) // and make first item as active
          ..getInfoForType(context, id: widget.gymId)
          ..getAllPhotos(context, widget.gymId)
          ..getAllLessons(context, true, id: widget.gymId)
              // get infos after the selected activity is set
              .then((value) {
            ref.read(activityProvider.notifier)
              ..getLessonsOfSelectedActivity(ref.watch(activityProvider).selectedActivity!, true)
              ..getPhotosOfSelectedActivity(ref.watch(activityProvider).selectedActivity!)
              ..getDescribtionAndPeculiarities(ref.watch(activityProvider).selectedActivity!);
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
    refreshController.dispose();
    super.dispose();
  }

  Future scrollToCalendar() async {
    final context = calendarSectionKey.currentContext;
    await Future.delayed(const Duration(milliseconds: 500));
    await Scrollable.ensureVisible(context!,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(activityProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SmartRefresher(
        controller: refreshController,
        header: const WaterDropMaterialHeader(
          distance: 40,
          backgroundColor: Colors.white,
          color: AppColors.blueColor,
        ),
        onRefresh: () async {
          ref.read(activityProvider.notifier)
            ..getListOf15CalendarDatesFromToday()
            ..getGymInfo(context, true, gymId: widget.gymId)
            ..getActivityTypes(context, false,
                ref.watch(mapProvider).selectedLessonTypeFromMap,
                gymId: widget.gymId)
            ..getInfoForType(context, id: widget.gymId)
            ..getAllPhotos(context, widget.gymId)
            ..getAllLessons(context, true, id: widget.gymId)
                // get infos after the selected activity is set
                .then((value) {
              ref.read(activityProvider.notifier)
                ..getPhotosOfSelectedActivity(
                    ref.watch(activityProvider).selectedActivity!)
                ..getDescribtionAndPeculiarities(
                    ref.watch(activityProvider).selectedActivity!)
                ..getLessonsOfSelectedActivity(
                    ref.watch(activityProvider).selectedActivity!, true);
            });
          await Future.delayed(const Duration(seconds: 1));
          refreshController.refreshCompleted();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TheOneWithImage(),
                32.verticalSpace,
                Contacts(event: event),
                32.verticalSpace,
                const GymDescription(),
                32.verticalSpace,
                TheOneWithChips(gymId: widget.gymId),
                32.verticalSpace,
                const RemainingVisits(),
                const ActivityDescription(),
                TheOneWithPhotos(event: event),
                const Speciality(),
                32.verticalSpace,
                TheOneWithCalendar(
                  event: event,
                  gymId: widget.gymId,
                ),
                TheOneWithLessons(
                  key: calendarSectionKey,
                  gymId: widget.gymId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
