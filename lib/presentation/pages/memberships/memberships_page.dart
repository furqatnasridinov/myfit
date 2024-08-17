import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_search_bar.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/pages/memberships/widget/widget.dart';

@RoutePage()
class MembershipsScreen extends ConsumerStatefulWidget {
  const MembershipsScreen({super.key});

  @override
  ConsumerState<MembershipsScreen> createState() => _MembershipsScreenState();
}

class _MembershipsScreenState extends ConsumerState<MembershipsScreen> {

  @override
  void initState() {
    //ref.read(membershipProvider.notifier).getMembershipByUserId(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchBar(
        showBackButton: false,           
        canNavigateToSettings: true,
      ),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Мои абонементы", fontSize: 20.sp, fontWeight: FontWeight.w600),
              32.verticalSpace,
              const FilterAndPayment(),
              32.verticalSpace,
              const CurrentMembershipCard(),
            ],
          ),
        ),
      ),
    );
  }
}