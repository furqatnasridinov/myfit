import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/membership/membership_notifier.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:myfit/presentation/components/custom_search_bar.dart';
import 'package:myfit/presentation/pages/buy_membership/widgets/widgets.dart';

@RoutePage()
class BuyMembershipScreen extends ConsumerStatefulWidget {
  final int gymId;
  const BuyMembershipScreen({super.key, required this.gymId});

  @override
  ConsumerState<BuyMembershipScreen> createState() => _BuyMembershipScreenState();
}

class _BuyMembershipScreenState extends ConsumerState<BuyMembershipScreen> {

  @override
  void initState() {
    final MembershipNotifier notifier = ref.read(membershipProvider.notifier);
    final int gymId = ref.read(activityProvider).gym?.id ?? 0;
    final List<MemberShip> userMemberships = ref.read(membershipProvider).membershipsOfUser;
    final int crmUserId = LocalStorage.getUserCrmId();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.resetLastInfos();
      notifier.getMembershipByGymId(context, gymId: gymId);
      if (userMemberships.isEmpty && crmUserId != 0) {
        notifier.getMembershipByUserId(context);
      }
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
    final String selectedActivity = ref.watch(membershipProvider).selectedActivity;
    final List<Subcategory> subcategories = ref.watch(membershipProvider).subCategories;
    final bool isBothSelected = selectedActivity.isNotEmpty && 
      (ref.watch(membershipProvider).selectedSubCategory != null || subcategories.isEmpty);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchBar(
        showBackButton: true,           
        canNavigateToSettings: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GymBlock(boughtAlready: false, gyms: [],),
              32.verticalSpace,
              const ActivitiesBlock(),
              32.verticalSpace,
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isBothSelected ? 1 : 0,
                child: const ResultList()),
            ],
          ),
        ),
      ),
    );
  }
}
