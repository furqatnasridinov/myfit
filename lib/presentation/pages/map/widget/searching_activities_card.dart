import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class SearchingActivitiesCard extends StatefulWidget {
  const SearchingActivitiesCard({super.key});

  @override
  State<SearchingActivitiesCard> createState() => _SearchingActivitiesCardState();
}

class _SearchingActivitiesCardState extends State<SearchingActivitiesCard> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(400);
      /* scrollController.animateTo(
        1000,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ); */
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 20,
        itemBuilder: (context, index) {
          return _skeletonFrame();
        },
      ),
    );
  }
}


Widget _skeletonFrame() {
  return Padding(
    padding: EdgeInsets.only(bottom: 5.h),
    child: SizedBox(
      height: 40.h,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.skeletonBg,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              SkeletonCard(width: 16.w, height: 16.h, borderRadius: 2.r),
              10.horizontalSpace,
              SkeletonCard(width: 170.w, height: 14.h, borderRadius: 4.r),
              const Spacer(),
              SkeletonCard(width: 8.w, height: 16.h, borderRadius: 2.r),
              5.horizontalSpace,
              Icon(
                Icons.keyboard_arrow_down,
                size: 18.sp,
                color: AppColors.skeletonSecondary,
              ),
              5.horizontalSpace,
              SkeletonCard(width: 30.w, height: 16.h, borderRadius: 2.r),
            ],
          ),
        ),
      ),
    ),
  );
}


      
      
      /* Column(
        children: [
          CustomCard(
            child: CustomText(
              text:"Собираем данные об активностях вокруг вас, скоро всё покажем, пожалуйста подождите",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          10.verticalSpace,
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
            return _skeletonFrame();
          },),
          
        ],
      ), */