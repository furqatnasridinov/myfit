import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/custom_search_bar.dart';
import 'package:myfit/presentation/pages/settings/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

@RoutePage()
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(settingsProvider.notifier)
    ..getAllAvailableSubscribtions(context)
    ..getListOfCities(context);
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(settingsProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomSearchBar(showBackButton: true, canNavigateToSettings: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Consumer(
              builder: (context, ref, child) {
                final bool currentSubscribtionNull = ref.watch(settingsProvider).currentSubscribtion == null;
                return Row(
                  children: [
                    CustomText(
                      text: "Настройки",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    if(currentSubscribtionNull)
                    GestureDetector(
                      onTap: () {
                        context.router.push(const SubscribtionSettingsRoute());
                      },
                      child: CustomText(
                        text: "Купить подписку",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blueText,
                      ),
                    ),
                  ],
                );
              },
            ),
            const FillInfosBlock(),
            32.verticalSpace,
            const MySubscribtion(),
            //32.verticalSpace,
            /* Two containers */
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(settingsProvider);
                return PersonalInfo(
                  event: event,
                  state: state,
                );
              },
            ),
            32.verticalSpace,
            const ApplicationSettings(),
          ],
        ),
      ),
    );
  }
}
