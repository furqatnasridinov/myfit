import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/membership/membership_notifier.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/custom_card.dart';

class ActivitiesBlock extends ConsumerWidget {
  const ActivitiesBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String selectedActivity = ref.watch(membershipProvider).selectedActivity;
    final Subcategory? selectedSubCategory = ref.watch(membershipProvider).selectedSubCategory;
    final bool showSelectActivity = selectedActivity.isEmpty;
    final List<Subcategory> subcategories = ref.watch(membershipProvider).subCategories;
     final bool isBothSelected = selectedActivity.isNotEmpty && 
      (ref.watch(membershipProvider).selectedSubCategory != null || subcategories.isEmpty);
    final bool showSelectSub = selectedSubCategory == null && selectedActivity.isNotEmpty && !isBothSelected;
   
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: CustomCard(
            width: double.infinity,
            child: showSelectActivity
                ? selectAnActivity()
                :  showSelectSub
                    ? selectSub(selectedActivity: selectedActivity)
                    : isBothSelected ? bothSelected() : const SizedBox(),
          ),
        ),
      ],
    );
  }
}


Widget selectAnActivity(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Выберите активность",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          16.verticalSpace,
          Consumer(
            builder: (context, ref, child) {
              final activities = ref.watch(activityProvider).activityTypes;
              final Map<String, dynamic> mapActivityWithSub = ref.watch(activityProvider).lessonTypesAndSubcategories;
              final MembershipNotifier notifier = ref.read(membershipProvider.notifier);
              if (activities == null || activities.isEmpty) {
                return const SizedBox();
              }
              return Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: List.generate(
                  activities.length,
                  (index) {
                    final activity = activities[index];
                    return activityChip(
                      activity: activity,
                      onTap: () {
                        notifier.setSelectedActivity(activity);
                        notifier.setSubCategories(mapActivityWithSub);
                      },
                    );
                  },),
              );
            },
          ),
        ],
      );
}

Widget selectSub({
  String selectedActivity = "Йога",
}){
  return Consumer(builder: (context, ref, child) {
    final List<Subcategory> subcategories = ref.watch(membershipProvider).subCategories;
    final MembershipNotifier notifier = ref.read(membershipProvider.notifier);
    //subcategories.removeWhere((element) => element.name == selectedActivity);
    if (subcategories.isEmpty) {
        return const SizedBox();
      }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          activityChip(
            activity: selectedActivity,
            onTap: () {
              notifier.resetSelectedActivity();
            },
          ),
          16.verticalSpace,
          CustomText(
            text: "Выберите подгруппу",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          16.verticalSpace,
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: List.generate(
              subcategories.length,
              (index) {
                final sub = subcategories[index];
                return activityChip(
                  activity: sub.name ?? "",
                  onTap: () {
                    notifier
                    ..setSelectedSubCategory(sub)
                    ..getMembershipsToShow();
                  },
                  showIcon: false,
                );
              },),
          ),
        ],
      );
  },);
}

Widget bothSelected() {
  return Consumer(
    builder: (context, ref, child) {
      final Subcategory? sub = ref.watch(membershipProvider).selectedSubCategory;
      final String selectedActivity = ref.watch(membershipProvider).selectedActivity;
      final MembershipNotifier notifier = ref.read(membershipProvider.notifier);
      return Row(
        children: [
          activityChip(
            activity: selectedActivity,
            isGreyBorder: true,
            onTap: () {
              notifier.resetSelectedActivity();
              notifier.resetSelectedSubCategory();
            },
          ),
           5.horizontalSpace,
           if (sub != null)
          CustomText(
            text: '/',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.fadedBlueBorder,
          ),
          if (sub != null)5.horizontalSpace,
          if (sub != null)
          activityChip(
            activity: sub.name ?? "",
            isGreyBorder: true,
            showIcon: false,
            onTap: () {
              notifier.resetSelectedSubCategory();
            },
          ),
        ],
      );
    },
  );
}

Widget activityChip({
  String activity = "Йога",
  Function()? onTap,
  showIcon = true,
  isGreyBorder = false,
  Key? key,
}) {
  final Color borderColor = isGreyBorder ? const Color.fromRGBO(226, 226, 226, 1) : AppColors.blueColor;
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: 34.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: borderColor),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon)
              SvgPicture.asset(AppHelpers.getIconSvg(activity)),
              if (showIcon) 5.horizontalSpace,
              CustomText(
                text: activity,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
