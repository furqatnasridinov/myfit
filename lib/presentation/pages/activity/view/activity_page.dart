// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/shake_widget.dart';
import 'package:myfit/presentation/pages/activity/widget/the_one_with_lessons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../infrastructure/models/data/user_subscribtion.dart';
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
  late ItemScrollController itemScrollController;
  late RefreshController refreshController;
  ScrollController scrollController = ScrollController();
  final calendarSectionKey = GlobalKey();
  final visitsRemaingKey = GlobalKey();
  final shakeKey = GlobalKey<ShakeWidgetState>();


  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    refreshController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
         // прокрутка
        if (ref.watch(activityProvider).isFromSearch) {
          scrollToCalendar();
        }
        final UserSubscription? currentSub = ref.read(settingsProvider).currentSubscribtion;
        final DateTime? currentSubEnds = currentSub != null ? DateTime.tryParse(ref.read(settingsProvider).currentSubscribtion!.endData!.replaceAll("T", " ") ) : null;
        ref.read(activityProvider.notifier)
          ..getListOf45CalendarDatesFromToday(currentSubEnds)
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
                Uri.parse("wss://myfit-russia.ru:8443/appGymPanel/${widget.gymId}"),
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

  void scrollCalendarToIndex() async{
    await itemScrollController.scrollTo(
        index: ref.watch(activityProvider).selectedDayFromSearchIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut);
    ref.read(activityProvider.notifier).setIsFromSearch(false);
  }

  Future<void> scrollToDontHaveSub()async{
    final context = visitsRemaingKey.currentContext;
    await Scrollable.ensureVisible(
      context!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    shakeKey.currentState?.shake();
    await Future.delayed(const Duration(seconds: 1));
    ref.read(activityProvider.notifier).setAnimationDontHaveSub(false);
  }


  @override
  Widget build(BuildContext context) {
    final event = ref.read(activityProvider.notifier);
    ref.listen(activityProvider, (previous, next) {
      // для скрола к календарю
      if (previous?.selectedDayFromSearchIndex !=next.selectedDayFromSearchIndex && 
            next.selectedDayFromSearchIndex != 9999 && next.isFromSearch) {
        scrollCalendarToIndex();
      }
      // для скрола к у вас нету подписки
      if (previous?.showAnimationDontHaveSubs != next.showAnimationDontHaveSubs &&
          next.showAnimationDontHaveSubs) {
          scrollToDontHaveSub();
      }
    },);
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
           final UserSubscription? currentSub = ref.read(settingsProvider).currentSubscribtion;
           final DateTime? currentSubEnds =  currentSub != null ? DateTime.tryParse(ref.read(settingsProvider).currentSubscribtion!.endData!.replaceAll("T", " ") ) : null;
          ref.read(activityProvider.notifier)
            ..getListOf45CalendarDatesFromToday(currentSubEnds)
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
                ..getPhotosOfSelectedActivity(ref.watch(activityProvider).selectedActivity!)
                ..getDescribtionAndPeculiarities(ref.watch(activityProvider).selectedActivity!)
                ..getLessonsOfSelectedActivity(ref.watch(activityProvider).selectedActivity!, true);
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
                TheOneWithImage(key: visitsRemaingKey),
                32.verticalSpace,
                Contacts(event: event),
                32.verticalSpace,
                const GymDescription(),
                32.verticalSpace,
                TheOneWithChips(gymId: widget.gymId),
                 RemainingVisits(shakeKey: shakeKey),
                const ActivityDescription(),
                TheOneWithPhotos(event: event),
                const Speciality(),
                32.verticalSpace,
                TheOneWithCalendar(
                  event: event,
                  gymId: widget.gymId,
                  itemScrollController: itemScrollController,
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
