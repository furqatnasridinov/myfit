import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/map/map_notifier.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

class FilterAndPayment extends StatelessWidget {
  const FilterAndPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final tabsRouter = AutoTabsRouter.of(context);
      final MapNotifier notifier = ref.read(mapProvider.notifier);
      final bool loading = ref.watch(membershipProvider).getAllMembershipsLoading;
      final bool showGymsOnlyWithMembership = ref.watch(mapProvider).showGymsOnlyWithMembership;
      if (loading) {
       return _skeleton();
      }
      return CustomCard(
      width: double.maxFinite,
      child: Column(
        children: [
          _iconAndText(
            onTap: () {
              if (showGymsOnlyWithMembership) {
                tabsRouter.setActiveIndex(2);
              }else{
                //context.router.push(const MapRoute());
                tabsRouter.setActiveIndex(2);
                notifier.setShowGymsOnlyWithMembership(true);
              }
            },
          ),
          10.verticalSpace,
          _iconAndText(
            iconPath: "assets/svg/card_icon.svg",
            text: "Настроить методы оплаты",
            onTap: () {
              context.router.push(const PaymentSettingsRoute());
            },
          ),
        ],
      ),
    );
    },);
  }
}

Widget _iconAndText({ 
  String iconPath = "assets/svg/location_filled.svg",
  String text = "Найти залы рядом со мной для покупки абонемента",
  Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: ColoredBox(
      color: Colors.transparent,
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 28.w,
            height: 28.h,
          ),
          10.horizontalSpace,
          Flexible(
              child: CustomText(
            text: text,
            fontSize: 14.sp,
            height: 1.1,
          )),
        ],
      ),
    ),
  );
}

Widget _skeleton(){
  return SizedBox(
    width: double.maxFinite,
    height: 105.h, //
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.skeletonBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding:  EdgeInsets.all(16.r),
        child: Column(children: [
          _iconAndTextSkeleton(),
          10.verticalSpace,
          _iconAndTextSkeleton(width: 150),
        ],),
      ),
    ),
  );
}

Widget _iconAndTextSkeleton({
  double width = 230,
}) {
  return Row(
    children: [
      SkeletonCard(
        height: 28,
        width: 28,
      ),
      10.horizontalSpace,
      Flexible(child: SkeletonCard(height: 14, width: width.w)),
    ],
  );
}