import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';
import 'package:myfit/presentation/pages/activity/widget/the_one_with_image.dart';
import 'package:myfit/presentation/pages/memberships/widget/activities_expandable.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import '../../../../infrastructure/models/response/user_schedules_response.dart';

class CurrentMembershipCard extends ConsumerWidget {
  const CurrentMembershipCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberShips = ref.watch(membershipProvider).membershipsOfUser;
    final bool loading = ref.watch(membershipProvider).getUserMembershipsLoading;
    
    if (loading) {
      return _skeleton();
    }
    if (!loading && memberShips.isEmpty) {
      return _noMembership();
    }
    if (memberShips.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: memberShips.length,
        itemBuilder: (context, index) {
          final MemberShip memberShip = memberShips[index];
          final List<String> subs = memberShip.lessonSubTypes
              ?.map((e) => e.name ?? "")
              .toList() ??
              [];
          return CustomCard(
            marginBottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // avatar and gymName
                _topSection(
                  memberShip: memberShip,
                  context: context,
                ),
                16.verticalSpace,
                _dateAndPrice(
                  price: memberShip.price.toString(),
                  endDate: memberShip.endDate ?? "",
                  type: AppHelpers.getMembershipTypeTranslated(
                      memberShip.type ?? ""),
                ),
                10.verticalSpace,
                ActivitiesExpandable(activities: memberShip.lessonTypes ?? []),
                16.verticalSpace,
                if(subs.isNotEmpty)
                Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CustomText(
                      text: "Включает:",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ActivitiesExpandable(
                  activities: subs,
                  maxLines: 2,
                  showIconOnChips: false,
                ),
                16.verticalSpace,
                timeLineIndicator(context, memberShip.endDate ?? "", memberShip.type ?? ""),
              ],
            ),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }
}                                                                                            
Widget _skeleton() {
  return SizedBox(
    width: double.maxFinite,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.skeletonBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.skeletonSecondary,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonCard(
                        width: 170,
                        height: 20,
                        borderRadius: 4,
                      ),
                      10.verticalSpace,
                      SkeletonCard(
                        width: 100,
                        height: 14,
                        borderRadius: 2,
                      ),
                    ],
                  ),
                ),
                10.horizontalSpace,
                SkeletonCard(
                  width: 37,
                  height: 37,
                  borderRadius: 8,
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: SkeletonCard(height: 34)),
                10.horizontalSpace,
                Expanded(
                  flex: 4,
                  child: SkeletonCard(height: 34))
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                SkeletonCard(height: 34, width: 77),
                10.horizontalSpace,
                SkeletonCard(height: 34, width: 120),
                10.horizontalSpace,
                SkeletonCard(height: 34, width: 34),
              ],
            ),
            16.verticalSpace,
            SkeletonCard(height: 16, width: 120, borderRadius: 4),
            10.verticalSpace,
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                SkeletonCard(height: 34, width: 120),
                SkeletonCard(height: 34, width: 80),
                SkeletonCard(height: 34, width: 130),
                SkeletonCard(height: 34, width: 110),
                SkeletonCard(height: 34, width: 34),
              ],
            ),
            16.verticalSpace,
            SkeletonCard(height: 4, width: double.maxFinite, borderRadius: 4),
          ],
        ),
      ),
    ),
  );
}

Widget _noMembership() {
  return CustomCard(
    child: Center(
        child: CustomText(
      text: "У вас еще нет купленных абонементов",
      fontSize: 14.sp,
    )),
  );
}                                  

Widget _topSection({
  required BuildContext context,
  required MemberShip memberShip,
}) {
  final List<Gym> gyms = memberShip.gyms ?? [];
  final bool isMoreThanOneGym = gyms.length > 1;
  final Gym gym = gyms[0];
  final bool noPhoto = gym.mainPictureUrl == null || gym.mainPictureUrl == '';
  final String mainPictureUrl = noPhoto
      ? "assets/images/avatar.png"
      : "${AppConstants.baseUrl}/image/${gym.mainPictureUrl}";
  return GestureDetector(
    onTap: () {
      if (isMoreThanOneGym) {
        AppHelpers.showCusomDialog(
          context: context,
          child: _dialogContent(
            gyms: gyms,
            context: context,
          ),
        );
      }
    },
    child: Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.blueColor,
              child: CircleAvatar(
                radius: 27.r,
                backgroundColor: Colors.white,
                backgroundImage: noPhoto
                    ? AssetImage(mainPictureUrl)
                    : NetworkImage(mainPictureUrl) as ImageProvider,
              ),
            ),
            if (isMoreThanOneGym) _badge(gyms.length - 1),
          ],
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: gym.name ?? "",
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              CustomText(
                text: gym.address ?? "",
                fontSize: 14.sp,
                height: 1.2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        10.horizontalSpace,
        UiDropDownMenu(
          dropDownItemsList: [
            {
              'title': 'Подробнее об абонементе',
              'icon': iconWrapper(
                svg: SvgPicture.asset(
                  "assets/svg/membership.svg",
                  height: 18.h,
                  width: 18.w,
                ),
              ),
              'action': () => {
                    context.router.push(
                      MembershipDetailsRoute(
                        membership: memberShip,
                        boughtAlready: true,
                      ),
                    )
                  }
            },
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
          ],
          customOffset: [-40.0.w, -65.0.h],
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

Widget _badge(int count) {
  return Positioned(
    right: 0,
    bottom: 0,
    child: SizedBox(
      width: 30.w,
      height: 30.w,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color.fromRGBO(226, 226, 226, 1)),
          color: Colors.white,
        ),
        child: Center(
          child: CustomText(
            text: "+$count",
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}

Widget _dialogContent({
  required List<Gym> gyms,
  required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomText(
          text: "Заведения, включённые в абонемент:",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600),
      16.verticalSpace,
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 440.h),
        child: Scrollbar(
          radius: Radius.circular(10.r),
          thickness: 7.w,
          child: ListView.builder(
            itemCount: gyms.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              double bottomPadding = gyms.length - 1 == index ? 0 : 16;
              return Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: gyms[index].name ?? "",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    CustomText(
                      text: gyms[index].address ?? "",
                      fontSize: 14.sp,
                      height: 1.1,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      16.verticalSpace,
      CustomButton(
        height: 40.h,
        buttonColor: AppColors.blueColor,
        borderColor: AppColors.blueBorder,
        textColor: Colors.white,
        fontSize: 14.sp,
        onPressed: () {
          context.router.pop();
        },
        text: "Закрыть",
      )
    ],
  );
}

Widget _dateAndPrice({
  String type = "На месяц",
  String endDate = "18.09.24г",
  String price = "5499",
}) {
  final String formatted = AppHelpers.getMembershipEndDate(endDate);
  return Row(
    children: [
      CustomCard(
        height: 34.h,
        radius: 8.r,
        paddingAll: 10.w,
        bottomPadding: 0,
        topPadding: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Center(
            child: CustomText(
              text: "На $type, до $formatted",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      const Spacer(),
      CustomCard(
        height: 34.h,
        radius: 8.r,
        paddingAll: 10.w,
        bottomPadding: 0,
        topPadding: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Center(
            child: CustomText(
              text: "$price ₽",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget timeLineIndicator(BuildContext context, String endDate, String type) {
  double currentProgress = 0;
  final double width = MediaQuery.of(context).size.width;
  final DateTime? end = endDate.isNotEmpty ? DateTime.parse(endDate.replaceAll("T", " ")) : null;
  if (end != null) {
    currentProgress = AppHelpers.getMembershipProgress(endDate: end, prolongation: type);
  }
  return Stack(
    children: [
      SizedBox(
        height: 4.h,
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(212, 229, 255, 1),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
      Positioned(
        left: 0,
        child: SizedBox(
          width: width * currentProgress,
          height: 4.h,
          child: DecoratedBox(
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.blueColor,
          )),
        ),
      ),
    ],
  );
}
