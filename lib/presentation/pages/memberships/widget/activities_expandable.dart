// ignore_for_file: unused_element, must_be_immutable
import 'dart:developer' as developer;
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/membership/membership_notifier.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/infrastructure/models/data/gym_with_activities_data.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/pages/activity/widget/speciality.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import '../../../../infrastructure/models/response/user_schedules_response.dart';

class ActivitiesExpandable extends StatefulWidget {
  final List<String> activities;
  final int maxLines;
  final bool showIconOnChips;
  bool showBigButton;
  bool canTap;
  bool isActivity;
  MemberShip? membership;
  ActivitiesExpandable({
    super.key,
    required this.activities,
    this.membership,
    required this.maxLines,
    required this.showIconOnChips,
    this.showBigButton = false,
    this.canTap = false,
    this.isActivity = false,
  });

  @override
  State<ActivitiesExpandable> createState() => _ActivitiesExpandableState();
}

class _ActivitiesExpandableState extends State<ActivitiesExpandable> {
  final Map<String, GlobalKey> keys = {};
  final GlobalKey sizedBoxKey = GlobalKey();
  int maxElements = 0;
  bool iterationCompleted = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    for (var activity in widget.activities) {
      keys[activity] = GlobalKey();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double maxWidth =sizedBoxKey.currentContext?.size?.width ?? double.maxFinite;
      final double buttonWidth = widget.showBigButton ? 170.w : 60.w;
      maxWidth = (maxWidth * widget.maxLines) - buttonWidth;
      double currentWidth = 0;
      int currentLine = 1;
      maxElements = 0;

      // расчитать размеры каждого чипа
      if (widget.activities.isEmpty) {
        iterationCompleted = true;
      } else {
        for (var activity in widget.activities) {
          final RenderBox? renderBox = keys[activity]!.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox is RenderBox) {
            final double width = renderBox.size.width;
            currentWidth += width + 10.w;
            if (currentWidth > maxWidth) {
              currentLine++;
              if (currentLine > widget.maxLines) {
                break;
              }
              currentWidth = width + 10.h; // Начинаем новый ряд
            }
            maxElements++;
          }
        }
        iterationCompleted = true;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final MembershipNotifier notifier = ref.read(membershipProvider.notifier);
      return SizedBox(
    key: sizedBoxKey,
    width: double.infinity,
    child: Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children:  iterationCompleted ? [
        for (var i = 0; i < widget.activities.length; i++)
          if (i < maxElements || isExpanded)
            _EachChipBuilder(
              key: keys[widget.activities[i]],
              activity: widget.activities[i],
              showIcon: widget.showIconOnChips,
              borderColor: const Color.fromRGBO(226, 226, 226, 1),
              onTap: widget.canTap ? () {
                if(widget.isActivity){
                  // select activity
                  notifier
                  ..resetSelectedSubCategory()
                  ..setSelectedActivity(widget.activities[i],selectGym: true);
                }else{
                  final Subcategory? subcategory = widget.membership?.lessonSubTypes?.firstWhere((element) => element.name == widget.activities[i]);
                  // select subcategory
                  notifier.resetSelectedActivity();
                  if (subcategory != null) {
                    notifier.setSelectedSubCategory(subcategory,selectGym: true);
                  }
                }
                AppHelpers.showCusomDialog(
                    context: context,
                    child: _infoDialogContent(context),
                );
              } : (){},
            ),
        if (widget.activities.length > maxElements || isExpanded)
          GestureDetector(
            onTap: () {
              if(widget.showBigButton){
                isExpanded = !isExpanded;
                setState(() {});
              }else{
                // show modal
                AppHelpers.showCusomDialog(
                  context: context,
                  child: _dialogContent(context, list: widget.activities),
                );
              }
            },
            child: widget.showBigButton ? 
              bigButton(
                remains: widget.activities.length - maxElements, 
                isOpened: isExpanded) : 
              miniButton(remains: widget.activities.length - maxElements),
          ),
      ] : widget.activities.map((activity) => _EachChipBuilder(
        key: keys[activity],
        activity: activity,
        showIcon: widget.showIconOnChips,
        borderColor: const Color.fromRGBO(226, 226, 226, 1),
        onTap: widget.canTap ? () {
                if(widget.isActivity){
                  // select activity
                  notifier.setSelectedActivity(activity,selectGym: true);
                }else{
                  // select subcategory
                  final Subcategory? subcategory = widget.membership?.lessonSubTypes?.firstWhere((element) => element.name == activity);
                  // select subcategory
                  notifier.resetSelectedActivity();
                  if (subcategory != null) {
                    notifier.setSelectedSubCategory(subcategory,selectGym: true);
                  }
                }
                AppHelpers.showCusomDialog(
                    context: context,
                    child: _infoDialogContent(context),
                );
              } : (){},
      )).toList(),
    ),
  );
    },);
  }
}


class _EachChipBuilder extends StatelessWidget {
  final String activity;
  final bool showIcon;
  final Color borderColor;
  final VoidCallback onTap;
  const _EachChipBuilder({super.key, required this.activity, required this.showIcon, required this.borderColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
}

Widget miniButton({
  required int remains,
}) {
  return SizedBox(
    height: 34.h,
    width: 60.w,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.blueColor),
      ),
      child: Center(
        child: CustomText(
          text: 'ещё $remains',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Widget bigButton({
  required int remains,
  bool isOpened = false,
  Function()? onTap,
}){
  final String text = isOpened ? "Скрыть" : "Показать ещё $remains";
  final double width = isOpened ? 170.w : 170.w;
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: 34.h,
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.blueColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: text,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            5.horizontalSpace,
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0, end: isOpened ? 1.0 : 0),
              builder: (BuildContext context, double angle, Widget? child) {
                return Transform.rotate(
                  angle: angle * pi,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: Colors.black.withOpacity(0.5),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _dialogContent(
  BuildContext context,
  {String title = "Полный список",
  required List<String> list,
  }
){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomText(
          text: title,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600),
      16.verticalSpace,
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 440.h),
        child: Scrollbar(
          radius: Radius.circular(10.r),
          thickness: 7.w,
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final String item = list[index];
              return CustomText(
                text: item ,
                fontSize: 14.sp,
                height: 1.1,
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

Widget _infoDialogContent(
  BuildContext context,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomText(
        text: "Заведение:",
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      //16.verticalSpace,
      Consumer(builder: (context, ref, child) {
        final MembershipNotifier notifier = ref.read(membershipProvider.notifier);
        final String selectedActivity = ref.watch(membershipProvider).selectedActivity;
        final Subcategory? selectedSubCategory = ref.watch(membershipProvider).selectedSubCategory;
        final String description = notifier.getDescriptionToShow();
        final String peculiarities = notifier.getPeculiarityToShow();
        final List<String> photos = notifier.getPhotosToShow();
        return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 440.h),
        child: Scrollbar(
          radius: Radius.circular(10.r),
          thickness: 7.w,
          child: Consumer(
            builder: (context, ref, child) {
              //final List<GymWithActivitiesData> list = ref.watch(membershipProvider).gymsWithActivitiesdatas;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _gymsHorizontalScroll(),
                    16.verticalSpace,
                    CustomText(
                      text: selectedActivity.isEmpty ? selectedSubCategory?.name ?? "" : selectedActivity, 
                      fontSize: 20.sp, 
                      fontWeight: FontWeight.w600),
                    16.verticalSpace,
                    CustomText(
                      text: "Описание:",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    5.verticalSpace,
                    CustomText(text: description, fontSize: 14.sp, height: 1.1),
                    _photosBlock(photos: photos),
                    _peculiarities(context,peculiarities: peculiarities),
                  ],
                ),
              );
            },
          ),
        ),
      );
      },),
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


Widget _gymsHorizontalScroll(){
  return Consumer(builder: (context, ref, child) {
    final List<GymWithActivitiesData> originalList = ref.watch(membershipProvider).gymsWithActivitiesdatas;
    final Gym? selectedGym = ref.watch(membershipProvider).selectedGym;
    final String selectedActivity = ref.watch(membershipProvider).selectedActivity;
    final Subcategory? selectedSubCategory = ref.watch(membershipProvider).selectedSubCategory;
    // Создаем изменяемую копию списка
    final List<GymWithActivitiesData> list = List.from(originalList);
    list.removeWhere((el) => el.activitiesWithAllInfos.every((element) => 
     selectedActivity.isNotEmpty ? element.activityName != selectedActivity : element.subs!.every((element) => element.name != selectedSubCategory?.name)));
    final List<Gym> gyms = list.map((e) => e.gym).toList();
    return Padding(
    padding: EdgeInsets.only(top: 10.h),
    child: SizedBox(
      height: 34.h,
      child: ListView.builder(
        itemCount: gyms.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final Gym gym = gyms[index];
          final bool isSelected = selectedGym != null && gym.id == selectedGym.id;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () {
                ref.read(membershipProvider.notifier).setSelectedGym(gym);
              },
              child: SizedBox(
                height: 34.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: isSelected ? AppColors.blueColor : Colors.white,
                    border: Border.all(color: isSelected ? AppColors.blueColor : AppColors.greyNew),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Center(
                      child: InterText(
                        text: gym.name ?? "",
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
  },);
}

Widget _photosBlock({
  required List<String> photos,
}){
  if (photos.isEmpty) {
    return const SizedBox();
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      16.verticalSpace,
      CustomText(
        text: "Фотографии",
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      10.verticalSpace,
      Container(
          padding: EdgeInsets.all(16.r),
          width: double.maxFinite,
          height: 79.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
            border: Border.all(
              color: AppColors.greyBorder,
              width: 1.w,
            ),
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final event = ref.read(activityProvider.notifier);
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final current = photos[index];
                  String linkToCompressedPhoto = event.getLinkToCompressedPhoto(current);
                  return InkWell(
                    onTap: () {
                      context.router.push(PhotoViewRoute(
                        index: index,
                        photos: photos,
                      ));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: SizedBox(
                          //color: Colors.red,
                          width: 47.w,
                          height: 47.h,
                          child: Hero(
                            tag: index,
                            child: CachedNetworkImage(
                              imageUrl:"${AppConstants.baseUrl}image/$linkToCompressedPhoto",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Image.asset(AppConstants.cristianBale);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )),
    ],
  );
}

Widget _peculiarities(BuildContext context, {String peculiarities = ""}) {
  if (peculiarities.isEmpty) {
    return const SizedBox(); 
  }
  return Padding(
    padding: EdgeInsets.only(top: 16.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Особенности посещения",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            GestureDetector(
              onTap: () {
                showSpecialityPopUp(context);
              },
              child: Container(
                width: 26.w,
                height: 26.h,
                padding: EdgeInsets.all(3.5.r),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  "assets/svg/question.svg",
                ),
              ),
            )
          ],
        ),
        10.verticalSpace,
        CustomText(
          text: peculiarities ?? "",
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          height: 1.0,
        ),
      ],
    ),
  );
}
