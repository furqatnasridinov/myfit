// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/membership/membership_notifier.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_search_bar.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/dummy_data.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';
import 'package:myfit/presentation/pages/activity/widget/the_one_with_image.dart';
import 'package:myfit/presentation/pages/buy_membership/widgets/activities_block.dart';
import 'package:myfit/presentation/pages/buy_membership/widgets/gym_block.dart';
import 'package:myfit/presentation/pages/memberships/widget/activities_expandable.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'widgets/result_list.dart';

@RoutePage()
class MembershipDetailsScreen extends ConsumerStatefulWidget {
  final MemberShip membership;
  bool? boughtAlready;
  MembershipDetailsScreen({
    super.key,
    required this.membership,
    this.boughtAlready = false,
  });

  @override
  ConsumerState<MembershipDetailsScreen> createState() =>
      _MembershipDetailsScreenState();
}

class _MembershipDetailsScreenState
    extends ConsumerState<MembershipDetailsScreen> {
  @override
  void initState() {
    final MembershipNotifier notifier = ref.read(membershipProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier
      ..resetLastInfos()
      ..getAllActivityDatas(membership: widget.membership);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> subs =
        widget.membership.lessonSubTypes?.map((e) => e.name ?? "").toList() ??
            [];
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
            children: [
              if (widget.boughtAlready == true) _textAndDropDown(),
              GymBlock(
                gyms: widget.membership.gyms ?? [],
                boughtAlready: widget.boughtAlready!,
              ),
              /* 32.verticalSpace,
              payments(widget.membership, widget.boughtAlready!), */
              32.verticalSpace,
              commonSubInfoBlock(
                  title: widget.membership.name ?? "",
                  text: widget.membership.description ?? "",
              ),
              if (widget.boughtAlready == false)
                activityAndSubs(widget.membership, !widget.boughtAlready!),
              if (widget.boughtAlready == true)
                Consumer(builder: (context, ref, child) {
                  final bool loading = ref.watch(membershipProvider).activityDatasLoading;
                  return CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(loading)
                      _skeleton(count: 3),
                      if(!loading)
                      ActivitiesExpandable(
                        activities: widget.membership.lessonTypes ?? [],
                        showBigButton: true,
                        showIconOnChips: true,
                        maxLines: 2,
                        canTap: true,
                        isActivity: true,
                        membership: widget.membership,
                      ),
                      16.verticalSpace,
                      if (subs.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: loading ? SkeletonCard(
                                width: 120, 
                                isBlue: true, 
                                height: 20,
                                borderRadius: 4) : CustomText(
                                text: "Включает:",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if(loading)
                            _skeleton(),
                            if(!loading)
                            ActivitiesExpandable(
                              activities: subs,
                              maxLines: 3,
                              showIconOnChips: false,
                              showBigButton: true,
                              canTap: true,
                              isActivity: false,
                              membership: widget.membership,
                            ),
                          ],
                        )
                    ],
                  ),
                );
                },),
              5.verticalSpace,
              timeLines(widget.membership),
              5.verticalSpace,
              commonSubInfoBlock(
                title: "Информация о доступных льготах и скидках:",
                text: widget.membership.privileges ?? "",
              ),
              commonSubInfoBlock(text: widget.membership.restrictions ?? ""),
              commonSubInfoBlock(
                title: "Условия отмены и заморозки абонемента:",
                text: widget.membership.freezingCancellation ?? "",
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

Widget _textAndDropDown() {
  return Padding(
    padding: EdgeInsets.only(top: 16.h, bottom: 32.h),
    child: Row(
      children: [
        CustomText(
          text: "Абонемент",
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        const Spacer(),
        UiDropDownMenu(
          dropDownItemsList: [
            {
              'title': 'Продлить абонемент',
              'icon': iconWrapper(
                svg: SvgPicture.asset(
                  "assets/svg/nextNext.svg",
                  height: 18.h,
                  width: 18.w,
                ),
              ),
              'action': () => {}
            },
            {
              'title': 'Отменить абонемент',
              'icon': SvgPicture.asset(
                "assets/svg/closeRedFilled.svg",
                width: 28.w,
                height: 28.h,
              ),
              'action': () => {}
            },
          ],
          customOffset: [-45.0.w, -35.0.h],
          width: 290.w,
          maxWidth: 290.w,
          dropDownChild: AnimationButtonEffect(
            child: SizedBox(
              width: 37.w,
              height: 37.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.blueColor),
                  color: Colors.white,
                ),
                child: Center(
                  child: Icon(Icons.more_vert, size: 22.r),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget payments(MemberShip membership, bool boughtAlready) {
  final String buttonText = boughtAlready == true ? "Продлить" : "Оплатить";
  final int price = membership.price ?? 0;
  final String prolongation = AppHelpers.getMembershipTypeTranslated(membership.type ?? "");
  return SizedBox(
    width: double.infinity,
    height: 40.h,
    child: Row(
      children: [
        SizedBox(
          height: 40.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: AppColors.blueColor),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  CustomText(text: "на $prolongation", fontSize: 14.sp),
                  10.horizontalSpace,
                  SvgPicture.asset("assets/svg/arrow_down.svg"),
                ],
              ),
            ),
          ),
        ),
        16.horizontalSpace,
         Expanded(
          child: SizedBox(
            height: 40.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: AppColors.blueColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(1.r),
                      child: SizedBox(
                        height: double.maxFinite,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6.r),
                              bottomLeft: Radius.circular(6.r),
                            ),
                          ),
                          child: Center(
                            child: CustomText(
                              text: "$price ₽",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(1.r),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final bool loading = ref
                              .watch(membershipProvider)
                              .buyMembershipLoading;
                          final MembershipNotifier notifier =
                              ref.read(membershipProvider.notifier);
                          return GestureDetector(
                            onTap: () {
                              if (!boughtAlready) {
                                HapticFeedback.mediumImpact();
                                onSuccess() async {
                                  await ref
                                      .read(settingsProvider.notifier)
                                      .getUser(context);
                                  notifier.getMembershipByUserId(context);
                                  notifier.getAllMemberships(context);
                                  notifier.setBuyLoading(false);
                                  context.router
                                      .replaceAll([const MembershipsRoute()]);
                                }

                                notifier.buyMemberShip(
                                  context,
                                  membershipId: membership.id ?? 0,
                                  onSuccess: onSuccess,
                                );
                              }
                            },
                            child: SizedBox(
                                height: double.maxFinite,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.blueColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5.r),
                                      bottomRight: Radius.circular(5.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: loading
                                        ? CupertinoActivityIndicator(
                                            radius: 10.r, color: Colors.white)
                                        : CustomText(
                                            text: buttonText,
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ), 
      ],
    ),
  );
}

Widget activityAndSubs(MemberShip membership, bool canReset) {
  return CustomCard(
    width: double.infinity,
    child: Consumer(
      builder: (context, ref, child) {
        final List<String> activities = membership.lessonTypes ?? [];
        final MembershipNotifier notifier =
            ref.read(membershipProvider.notifier);
        /*final List<Subcategory> subcategories = ref.watch(membershipProvider).subCategories;
        final Subcategory? selectedSubCategory = ref.watch(membershipProvider).selectedSubCategory;
       final List<Subcategory>? subActivities = selectedSubCategory !=null &&  membership.lessonSubTypes!.isNotEmpty && 
        membership.lessonSubTypes?.any((el)=> el.id == selectedSubCategory.id) == true ? membership.lessonSubTypes : [];
        subActivities?.removeWhere((element) => subcategories.any((el) => el.id == element.id) == false); */
        final List<Subcategory>? subActivities = membership.lessonSubTypes;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: activities
                  .map(
                    (e) => activityChip(
                      activity: e,
                      onTap: () {
                        if (canReset) {
                          notifier
                            ..resetSelectedActivity()
                            ..resetSelectedSubCategory();
                          context.router.pop();
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
            if (subActivities!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  CustomText(
                    text: "Включает:",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  5.verticalSpace,
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: subActivities
                        .map((e) => activityChip(
                              activity: e.name ?? "",
                              isGreyBorder: true,
                              showIcon: false,
                              onTap: () {
                                if (canReset) {
                                  notifier.resetSelectedSubCategory();
                                  context.router.pop();
                                }
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
          ],
        );
      },
    ),
  );
}

Widget timeLines(MemberShip membership) {
  final List<Map<String, dynamic>> weekdays = DummyData.weekdays;
  final List<int> selectedIds =
      AppHelpers.getWeekdayIds(membership.daysOfWeek ?? []);
  final String startTime =
      membership.startTime ?? membership.gyms?.first.startTime ?? "";
  final String endTime =
      membership.endTime ?? membership.gyms?.first.endTime ?? "";
  return CustomCard(
    width: double.maxFinite,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: "Расписание: ",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            10.horizontalSpace,
            CustomText(text: "c $startTime до $endTime", fontSize: 14.sp),
          ],
        ),
        5.verticalSpace,
        SizedBox(
          height: 35.h,
          child: ListView.builder(
            itemCount: weekdays.length,
            itemBuilder: (context, index) {
              return weekday(
                  isSelected: selectedIds.contains(index + 1),
                  text: weekdays[index]["name"]);
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    ),
  );
}

Widget commonSubInfoBlock({
  String title = "Ограничения:",
  String text = "Доступно для всех участников",
}) {
  if (text.isEmpty) {
    return const SizedBox();
  }
  return CustomCard(
    width: double.maxFinite,
    marginBottom: 5.h,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        5.verticalSpace,
        CustomText(
          text: text,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.1,
        ),
      ],
    ),
  );
}

Widget _skeleton({
  int count = 5,
}){
  return Wrap(
    spacing: 10.w,
    runSpacing: 10.h,
    children: List.generate(
      count,
      (index) => SkeletonCard(
        borderRadius: 8,
        height: 34,
        width: 120 + index * 10,
        isBlue: true,
      ),
    ),
  );
}