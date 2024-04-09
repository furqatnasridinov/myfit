// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:activity/application/activity/activity_provider.dart';
import 'package:activity/application/main2/main2_provider.dart';
import 'package:activity/application/map/map_provider.dart';
import 'package:activity/application/settings/settings_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/pages/main2/widget/main2_header.dart';
import 'package:activity/presentation/pages/main2/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@RoutePage()
class Main2Screen extends ConsumerStatefulWidget {
  const Main2Screen({super.key});

  @override
  ConsumerState<Main2Screen> createState() => _LoginScreen();
}

class _LoginScreen extends ConsumerState<Main2Screen> {
  final mapControllerCompleter = Completer<YandexMapController>();
  late final WebSocketChannel channel;
  late RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(settingsProvider.notifier)
        ..requestNotificationPermissions()
        ..setUserInfos();
      ref.read(mapProvider.notifier).getUserLocation().then((value) {
        ref.read(mapProvider.notifier).getYandexMapImage(
              context,
            );
      });
      ref.read(main2Provider.notifier)
        ..getNearestLesson(context)
        ..getUserStatsMonth(context);

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

  @override
  Widget build(BuildContext context) {
    final nearestLesson = ref.watch(main2Provider).nearestLesson;
    final event = ref.read(main2Provider.notifier);

    debugPrint("user id ${LocalStorage.getUserId()}");
    debugPrint("token ${LocalStorage.getToken()}");
    //LocalStorage.removeToken();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const Main2Header(
        showBackButton: false,
        canNavigateToSettings: true,
      ),
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
          child: Stack(
            children: [
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 26.w),
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
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: FirstTwoCards(
                        event: event,
                      ),
                    ),
                    32.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: nearestLesson == null
                          ? const PlaceholderComingActivity() //button "Найти себе занятие"
                          : ComingActivity(
                              nearestLesson: nearestLesson,
                              event: event,
                            ),
                    ),
                    32.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 25.w),
                      child: CustomText(
                        text: 'Бассейны поблизости',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    10.verticalSpace,
                    Consumer(builder: (context, ref, child) {
                      final mapScreenShot =
                          ref.watch(mapProvider).mapScreenShot;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: mapScreenShot == null
                            ? const Main2MapPlaceHolder()
                            : Main2Map(
                                child: Image.memory(
                                  mapScreenShot,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Main2MapPlaceHolder();
                                  },
                                ),
                              ),
                      );
                    }),
                    32.verticalSpace,
                    const DecoratedTextOne(),
                  ],
                ),
              ),

              // scan bottom container
              /* const Positioned(
            bottom: 0,
            child: BottomScanContainer(),
          ), */
            ],
          ),
        ),
      ),

      /* */
    );
  }
}
