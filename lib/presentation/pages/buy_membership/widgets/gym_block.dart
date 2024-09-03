// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';
import 'package:myfit/presentation/pages/activity/widget/the_one_with_image.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import '../../../../infrastructure/models/response/user_schedules_response.dart';

class GymBlock extends StatefulWidget {
  final List<Gym> gyms;
  final bool boughtAlready;
  const GymBlock({super.key, required this.gyms, required this.boughtAlready});

  @override
  State<GymBlock> createState() => _GymBlockState();
}

class _GymBlockState extends State<GymBlock> {
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Consumer(builder: (context, ref, child) {
      final Gym gymFormarred = Gym(
        address: ref.read(activityProvider).gym?.address ?? '',
        id: ref.read(activityProvider).gym?.id ?? 0,
        mainPictureUrl: ref.read(activityProvider).gym?.mainPictureUrl ?? '',
        name: ref.read(activityProvider).gym?.name ?? '',
      );
      final List<Gym> _gyms = widget.boughtAlready ? widget.gyms : [gymFormarred];
      final int itemCount = isExpanded ? _gyms.length : 1;
      return Column(
        children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: itemCount,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final Gym gym = _gyms[index];
              final bool noPhoto = gym.mainPictureUrl == null || gym.mainPictureUrl == '';
              final String mainPictureUrl = noPhoto ? "assets/images/avatar.png" : "${AppConstants.baseUrl}/image/${gym.mainPictureUrl}";
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: UiDropDownMenu(
                customOffset: [-5.0.w, -60.0.h],
                width: 290.w,
                maxWidth: 290.w,
                leftCornerShape: true,
                dropDownItemsList: [
                        {
                          'title': 'Подробнее о заведении',
                          'icon': iconWrapper(
                            svg: SvgPicture.asset(
                              "assets/svg/location.svg",
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          'action': () => {
                            context.router.push(
                              ActivityRoute(gymId: gym.id ?? 0),
                            )
                          }
                        },
                        {
                          'title': 'Абонементы этого заведения',
                          'icon': iconWrapper(
                            svg: SvgPicture.asset(
                              "assets/svg/membership.svg",
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          'action': () => {
                            context.router.push(BuyMembershipRoute(gymId: gym.id ?? 0))
                          }
                        },
                      ],
                dropDownChild: SizedBox(
                  //height: 60.h,
                  width: width,
                  child: Row(
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
                      10.horizontalSpace,
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: gym.name ?? '',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            CustomText(
                              text: gym.address ?? '',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),),
              );
            },
          ),
        ),
        
        if(_gyms.length > 1)
          GestureDetector(
            onTap: toggleExpand,
            child: ColoredBox(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: !isExpanded
                            ? "Показать еще ${_gyms.length - 1} заведения"
                            : "Скрыть",
                        fontSize: 14.sp,
                      ),
                      10.horizontalSpace,
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 0, end: isExpanded ? 1.0 : 0),
                        builder: (BuildContext context, double angle,
                            Widget? child) {
                          return Transform.rotate(
                            angle: angle * pi,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 18.sp,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
            ),
          ),
        ],
      );
    },);
  }
}