import 'dart:async';
import 'package:activity/application/map/map_provider.dart';
import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/pages/main2/widget/main2_header.dart';
import 'package:activity/presentation/pages/main2/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@RoutePage()
class Main2Screen extends ConsumerStatefulWidget {
  const Main2Screen({super.key});

  @override
  ConsumerState<Main2Screen> createState() => _LoginScreen();
}

class _LoginScreen extends ConsumerState<Main2Screen> {
  final mapControllerCompleter = Completer<YandexMapController>();
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  final layerlink = LayerLink();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(mapProvider.notifier).getUserLocation();
      ref.read(scheduleProvider.notifier)
        ..getNearestLesson(context)
        ..getUserStatsMonth(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleProvider);
    final event = ref.read(scheduleProvider.notifier);
    
    //LocalStorage.removeToken();
    if (kDebugMode) {
      //print("token ${LocalStorage.getToken()}");
    }
    if (controller.text.isEmpty && state.schedulesFoundBySearching.isNotEmpty) {
      event.cleanSearchList();
    }

    return PopScope(
      //canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: Main2Header(
          state: state,
          event: event,
          controller: controller,
        ),
        body: state.isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      controller: scrollController,
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
                              state: state,
                              event: event,
                            ),
                          ),
                          32.verticalSpace,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: state.nearestLesson == null
                                ? const PlaceholderComingActivity()
                                : ComingActivity(
                                    state: state,
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child:  Container(
                                width: double.maxFinite,
                                height: 150.h,
                                color: Colors.red,
                              ) 
                               // Main2Map(mapState: mapState),
                          ),
                          32.verticalSpace,
                          const DecoratedTextOne(),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: state.isSearchbarOpened
                          ? OverlayLikeMain2(
                              state: state,
                              event: event,
                              controller: controller,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
