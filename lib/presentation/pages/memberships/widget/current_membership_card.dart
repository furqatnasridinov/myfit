import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/dummy_data.dart';
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';
import 'package:myfit/presentation/pages/activity/widget/the_one_with_image.dart';
import 'package:myfit/presentation/pages/buy_membership/widgets/widgets.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

import '../../../../infrastructure/models/response/user_schedules_response.dart';

class CurrentMembershipCard extends StatelessWidget {
  const CurrentMembershipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Gym> gyms = DummyData.dummyGyms;
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avatar and gymName
          _topSection(
            gyms: gyms,
            context: context,
          ),
          16.verticalSpace,
          _dateAndPrice(),
          10.verticalSpace,
          _activities(),
          16.verticalSpace,
          _subCategories(),
          16.verticalSpace,
          timeLineIndicator(context),
        ],
      ),
    );
  }
}


Widget _topSection({
  required List<Gym> gyms,
  required BuildContext context,
}) {
  final bool isMoreThanOneGym = gyms.length > 1;
  final Gym gym = gyms[0];
  final bool noPhoto = gym.mainPictureUrl == null || gym.mainPictureUrl == '';
  final String mainPictureUrl = noPhoto ? "assets/images/avatar.png" : "${AppConstants.baseUrl}/image/${gym.mainPictureUrl}";
  return GestureDetector(
    onTap: (){
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
            if(isMoreThanOneGym)
            _badge(gyms.length -1),
          ],
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Top DOG Fight Club",
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
                CustomText(
                text: "ул. Лёни Ленина, д. 12, БЦ “Big Мук”",
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
                context.router.push(MembershipDetailsRoute(membership: MemberShip(
                  daysOfWeek: ["MONDAY"],
                  description: "cdcdcd",
                  endTime: "20:00",
                  gyms: gyms,
                  id: 1,
                  startTime: "10:00",
                  name: "name",
                  price: 1000,
                  privileges: "privileges",
                  type: "YEAR",
                  restrictions: "restrictions",
                  lessonTypes: ["lessonTypes"],
                  lessonSubTypes: [],
                  freezingCancellation: "Возможность заморозки и отмены абонемента"),
                  boughtAlready: true))
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
}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomText(text: "Заведения, включённые в абонемент:", fontSize: 16.sp, fontWeight: FontWeight.w600),
      16.verticalSpace,
      ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 440.h
        ),
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
          },),
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

Widget _dateAndPrice(){
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
                text: "На месяц, до 18.09.24г",
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
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Center(
              child: CustomText(
                text: "5499 ₽",
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
        ),
      ),
    ],
  );
}

Widget _activities(){
  const List<String> activities = ["Бокс", "Кроссфит", "Йога","Бокс", "Кроссфит", "Йога"];
  return SizedBox(
    //height: 34.h,
    width: double.infinity,
    child: Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: activities.map((activity) {
        return activityChip(activity: activity);
      }).toList(),
    ),
  );
}

Widget _subCategories(){
  const List<String> subCategories = ["Общая тренировка", "Спарринг", "Николай Борисович","Зал"];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomText(
        text: "Включает:",
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      10.verticalSpace,
      SizedBox(
        //height: 34.h,
        width: double.infinity,
        child: Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: subCategories.map((subCategory) {
            return activityChip(activity: subCategory);
          }).toList(),
        ),
      ),
    ],
  );
}

Widget timeLineIndicator(BuildContext context){
  final double width = MediaQuery.of(context).size.width;
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
          width: width / 3,
          height: 4.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: AppColors.blueColor,
            )
          ),
        ),
      ),
    ],
  );
}