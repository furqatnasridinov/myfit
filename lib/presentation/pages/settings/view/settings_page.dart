import 'package:activity/application/settings/settings_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/pages/settings/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(settingsProvider.notifier).setUserInfos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);
    final event = ref.watch(settingsProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const SettingsHeader(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            CustomText(
              text: "Настройки",
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            32.verticalSpace,
            const MySubscribtion(),
            32.verticalSpace,
            PersonalInfo(
              event: event,
              state: state,
            ),
            32.verticalSpace,
            const ApplicationSettings(),
          ],
        ),
      ),
    );
  }
}
