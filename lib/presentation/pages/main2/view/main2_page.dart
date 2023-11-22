import 'dart:async';
import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ya_map.dart';
import 'package:activity/presentation/pages/main2/widget/main2_header.dart';
import 'package:activity/presentation/pages/main2/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(scheduleProvider.notifier)
        ..getNearestLesson(context)
        ..getUserStatsMonth(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleProvider);
    final event = ref.read(scheduleProvider.notifier);
    //print("nearest lesson >> ${state.nearestLesson?.bodyData?.description} ");

    print("whenActivityStarts on duration ${state.whenActivityStarts}");

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const Main2Header(),
      body: state.isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
            bottom: false,
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Padding(
                      padding:  EdgeInsets.only(left: 36.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: 'Привет, George!',
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
                    10.verticalSpace,
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
                      child: const UiYaMap(),
                    ),
                    70.verticalSpace,
                    const DecoratedTextOne(),
                  ],
                ),
              ),
          ),
    );
  }
}
