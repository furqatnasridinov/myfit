import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_search_bar.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/pages/payments_settings/widget/payment_section.dart';
import 'package:myfit/presentation/pages/payments_settings/widget/payments_history.dart';

@RoutePage()
class PaymentSettingsScreen extends StatelessWidget {
  const PaymentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchBar(
        showBackButton: true,
        canNavigateToSettings: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Настройка оплаты",
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
              32.verticalSpace,
              const PaymentSection(),
              const PaymentsHistory(),
            ],
          ),
        ),
      ),
    );
  }
}
