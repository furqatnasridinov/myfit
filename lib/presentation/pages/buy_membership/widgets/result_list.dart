import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/dummy_data.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

class ResultList extends StatelessWidget {
  const ResultList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final List<MemberShip> memberships = ref.watch(membershipProvider).membershipsToShow;
      if (memberships.isEmpty) {
        return noMembershipFound(); 
      }
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Доступные абонементы:",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        10.verticalSpace,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: memberships.length,
          itemBuilder: (context, index) {
            final List<MemberShip> userMemberships = ref.watch(membershipProvider).membershipsOfUser;
            final bool boughtAlready = userMemberships.any((element) => element.id == memberships[index].id);
          final MemberShip membership = memberships[index];
          return membershipCard(
            context: context,
            membership: membership,
            boughtAlready: boughtAlready,
          );
        },
        ),
      ],
    );
    },);
  }
}

Widget membershipCard({
  required BuildContext context,
  required MemberShip membership, 
  required bool boughtAlready,
}) {
  List<int> selectedWeekdaysIds = AppHelpers.getWeekdayIds(membership.daysOfWeek ?? membership.gyms?.first.daysOfWeek ?? []);
  final List<Map<String, dynamic>> weekdays = DummyData.weekdays;
  final String startTime = membership.startTime ?? membership.gyms?.first.startTime ?? "";
  final String endTime = membership.endTime ?? membership.gyms?.first.endTime ?? "";
  return GestureDetector(
    onTap: () {
      context.router.push( MembershipDetailsRoute(membership: membership, boughtAlready: boughtAlready));
    },
    child: Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: CustomCard(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: CustomText(
                    text: membership.name ?? "",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 40.h,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: const Color.fromRGBO(226, 226, 226, 1)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: REdgeInsets.symmetric(horizontal: 5.w),
                            child: CustomText(
                              text: "от ${membership.price} ₽",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            10.verticalSpace,
            CustomText(
              text: membership.description ?? "",
              fontSize: 14.sp,
              height: 1.2,
            ),
            10.verticalSpace,
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
                  return weekday(isSelected: selectedWeekdaysIds.contains(index +1), text: weekdays[index]["name"]);
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget noMembershipFound(){
  return SizedBox(
    width: double.infinity,
    child: CustomCard(
      child: Center(
        child: CustomText(
          text: "Под выбранными вами параметрами абонементы не найдены. Попробуйте изменить параметры поиска.",
          fontSize: 14.sp,
        ),
      ),
    ),
  );
}

Widget weekday({
  bool isSelected = false,
  String text = "Пн",
}){
  final Color bgColor = isSelected ? AppColors.blueColor: const Color.fromRGBO(243, 243, 243, 1) ;
  final Color textColor = isSelected ? Colors.white : AppColors.greyText;
  return Padding(
    padding: EdgeInsets.only(right: 5.w),
    child: SizedBox(
      width: 33.w,
      height: 33.h,
      child: DecoratedBox(decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: CustomText(
              text: text,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    ),
  );
}