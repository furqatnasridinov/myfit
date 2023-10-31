import 'package:activity/application/main/main_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/pages/main/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _BlogScreen();
}

class _BlogScreen extends ConsumerState<MainScreen> {
  int activeStepState = 1;
  int dotCount = 3;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(mainProvider.notifier).getAdvantages(context);
      ref.read(mainProvider.notifier).getSubscribtions(context);
      ref.read(mainProvider.notifier).getComments(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainProvider);
    final event = ref.read(mainProvider.notifier);
    print(
        "state.advantages?.bodyData.lenth >>    ${state.advantages?.bodyData?.length}");
    print(
        "state.subscribtions?.bodyData.lenth>>  ${state.subscribtions?.bodyData?.length}");
    print(
        "state.comments?.bodyData.lenth>>  ${state.comments?.bodyData?.length}");
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const MainHeader(),
      body: state.isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 15.h),
                child: Column(
                  children: [
                    const TheOneWithCards(),
                    32.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        bottom: 10.0.h,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: 'О преимуществах',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TheOneWithAdvantages(
                      state: state,
                      event: event,
                    ),
                    32.verticalSpace,
                    const TheOneWithMap(),
                    32.verticalSpace,
                    const TheOneWithButton(),
                    32.verticalSpace,
                    TheOneWithComments(
                      event: event,
                      state: state,
                    ),
                    32.verticalSpace,
                  ],
                ),
              ),
            ),
    );
  }
}
