// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:developer';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/main2/main2_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:myfit/presentation/components/custom_search_bar.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/pages/main2/widget/widget.dart';
import 'package:myfit/presentation/pages/schedule/widget/bottom_scan_container.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@RoutePage()
class Main2Screen extends ConsumerStatefulWidget {
  const Main2Screen({super.key});

  @override
  ConsumerState<Main2Screen> createState() => _LoginScreen();
}

class _LoginScreen extends ConsumerState<Main2Screen> {
  late final WebSocketChannel channel;
  Timer? _timer;
  late RefreshController refreshController = RefreshController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: false);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(main2Provider.notifier)
        ..getNearestLesson(context)
        ..getUserStatsMonth(context);
      ref.read(settingsProvider.notifier)
        ..getUser(context)
        ..requestNotificationPermissions()
        ..setUserInfos()
        ..getCompletedLessonTypes(context) // for known activities
        ..getWaitingLessonTypes(context) // for known activities
        ..getUserSubscribtions(context);
      ref.read(mapProvider.notifier)
        ..getUserLocation()
        ..getRecommendationForVisit(context);
      // web socket for updating lesson states
      channel = IOWebSocketChannel.connect(
          Uri.parse(
              "ws://77.222.53.122:8080/appSchedulePanel/${LocalStorage.getUserId()}"),
          headers: {'Authorization': 'Bearer ${LocalStorage.getToken()}'});
      ref.read(activityProvider.notifier).handleWebSocket(channel, context);
    });
  }

  @override
  void dispose() {
    refreshController.dispose();
    channel.sink.close();
    super.dispose();
  }

  void startUpdatingNearestLesson() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      ref.read(main2Provider.notifier).determineWhenActivityStarts(
            ref.watch(main2Provider).lessonStartsAt!,
            ref.watch(main2Provider).lessonEndsAt!,
          );
    });
  }

  void stopUpdatingNearestLesson() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    //final nearestLesson = ref.watch(main2Provider).nearestLesson;
    final event = ref.read(main2Provider.notifier);
    log("login time ${LocalStorage.getLoginTime()}");
    log("user id ${LocalStorage.getUserId()}");
    log("token ${LocalStorage.getToken()}");
    log("known activities ${ref.watch(settingsProvider).knownActivities}");
    log("when photo access opens >> ${LocalStorage.getWhenUploadingPhotoOpens()}");
    log("selected city lat >> ${LocalStorage.getSelectedCityLat()}");
    log("selected city lon >> ${LocalStorage.getSelectedCityLon()}");
    //LocalStorage.removeToken();
    ref.listen(main2Provider, (previous, next) {
      if (previous!.lessonEndsAt != next.lessonEndsAt &&
          next.lessonEndsAt != next.lessonStartsAt &&
          !next.lessonIsAlreadyStarted) {
        if (next.lessonStartsAt != null && next.lessonEndsAt != null) {
          startUpdatingNearestLesson();
        } else {
          stopUpdatingNearestLesson();
        }
      }
      // Если урок начинается в ближайшие 40 минут запускаем stream observable
      if (previous.lessonStartsWithin40Minutes !=
              next.lessonStartsWithin40Minutes &&
          next.lessonStartsWithin40Minutes) {
        event.streamToListenDateTime();
      }
    });
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: CustomSearchBar(
        showBackButton: false,
        canNavigateToSettings: true),
      body: SmartRefresher(
        controller: refreshController,
        header: const WaterDropMaterialHeader(
          backgroundColor: Colors.white,
          color: AppColors.blueColor,
        ),
        onRefresh: () async {
          await ref.read(main2Provider.notifier).getNearestLesson(context);
          await ref.read(main2Provider.notifier).getUserStatsMonth(context);
          refreshController.refreshCompleted();
        },
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Приветствие
                    SliverPadding(
                      padding: EdgeInsets.only(left: 26.w).copyWith(top: 10.h),
                      sliver: SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: LocalStorage.getUserName().isNotEmpty
                                ? "Привет, ${LocalStorage.getUserName()}!"
                                : 'Привет, George!',
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),

                    // Статистика
                    const SliverToBoxAdapter(
                      child: UserStatsBlock(),
                    ),

                    // Ближайшее занятие
                    Consumer(builder: (context, ref, child) {
                      final nearestLesson =ref.watch(main2Provider).nearestLesson;
                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 5.h),
                        sliver: SliverToBoxAdapter(
                          child: nearestLesson == null
                              ? const PlaceholderComingActivity() //button "Найти себе занятие"
                              : ComingActivity(nearestLesson: nearestLesson, event: event),
                        ),
                      );
                    }),

                    // Бассейны поблизости
                    SliverPadding(
                      padding: EdgeInsets.only(left: 25.w).copyWith(top: 32.h),
                      sliver: SliverToBoxAdapter(
                        child: Consumer(
                          builder: (context, ref, child) {
                            final recommendedGyms =
                                ref.watch(mapProvider).recommendedGyms;
                            return recommendedGyms.isEmpty
                                ? const SizedBox.shrink()
                                : CustomText(
                                    text: 'Рекомендуемые занятия',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  );
                          },
                        ),
                      ),
                    ),

                    // Карта
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w)
                          .copyWith(top: 10.h),
                      sliver: SliverToBoxAdapter(
                        child: Consumer(builder: (context, ref, child) {
                          final showRecommended =
                              ref.watch(mapProvider).showRecommended;
                          final recommendedGyms =
                              ref.watch(mapProvider).recommendedGyms;
                          return recommendedGyms.isEmpty
                              ? const SizedBox.shrink()
                              : Main2Map(
                                  mapEvent: ref.read(mapProvider.notifier),
                                  showRecommended: showRecommended,
                                  showOnlyKnown:ref.watch(mapProvider).showOnlyKnown,
                                  gyms: recommendedGyms["gyms"],
                                );
                        }),
                      ),
                    ),

                    // Декоративный текст
                    SliverPadding(
                      padding: EdgeInsets.only(top: 32.h),
                      sliver: SliverToBoxAdapter(
                          child: Consumer(builder: (context, ref, child) {
                        final recommendedGyms =
                            ref.watch(mapProvider).recommendedGyms;
                        return recommendedGyms.isEmpty
                            ? const SizedBox()
                            : DecoratedTextOne(
                                lesson: recommendedGyms["lessonType"] ?? "",
                                usersCount:recommendedGyms["countUsers"].toString(),
                              );
                      })),
                    ),
                  ],
                ),
              ),

              // Кнопка сканирования
              const BottomScanContainer(),
            ],
          ),
        ),
      ),

      /* */
    );
  }
}
