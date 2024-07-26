import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/custom_textfield.dart';
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';
import 'package:myfit/presentation/pages/activity/skeletons/photo_skeleton.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../infrastructure/services/app_constants.dart';

class TheOneWithImage extends StatefulWidget {
  const TheOneWithImage({Key? key}) : super(key: key);

  @override
  State<TheOneWithImage> createState() => _TheOneWithImageState();
}

late TextEditingController errorController;
late TextEditingController complaintController;
late FocusNode focusNode;

class _TheOneWithImageState extends State<TheOneWithImage> {
  @override
  void initState() {
    super.initState();
    errorController = TextEditingController();
    complaintController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    errorController.dispose();
    complaintController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final mainPictureUrl = ref.watch(activityProvider).gym?.mainPictureUrl;
      final name = ref.watch(activityProvider).gym?.name;
      final address = ref.watch(activityProvider).gym?.address;
      final loading = ref.watch(activityProvider).isGymLoading;
      return loading ? const PhotoSkeleton() : Stack(
        children: [
          SizedBox(
            height: 210.h,
            width: double.maxFinite,
            child: Hero(
              tag: mainPictureUrl ?? "",
              child: CachedNetworkImage(
                imageUrl: "${AppConstants.baseUrl}image/$mainPictureUrl",
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/images/avatar.png",
                    fit: BoxFit.cover,
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
             /*  if (mainPictureUrl != null && mainPictureUrl.isNotEmpty) {
                context.pushRoute(PhotoViewRoute(photos: [mainPictureUrl], index: 0));
              } */
            },
            child: SizedBox(
              height: 210.h,
              width: double.maxFinite,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.70),
                    ],
                    stops: const [
                      0.02,
                      0.35,
                      0.67,
                      1.5,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back icon
                  GestureDetector(
                    onTap: () {
                      context.popRoute();
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/svg/back_icon.svg",
                          width: 5.w,
                          height: 10.h,
                        ),
                      ),
                    ),
                  ),

                  // name and description
                  10.horizontalSpace,
                  SizedBox(
                    //color: Colors.red,
                    width: 246.w,
                    child: CustomText(
                      color: Colors.white,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      //text: "Top DOG Fight Club",
                      text: name ?? "",
                    ),
                  ),
                  10.horizontalSpace,
                  UiDropDownMenu(
                    dropDownItemsList: [
                      {
                        'title': 'Сообщить об ошибке на странице',
                        'icon': SvgPicture.asset(
                          "assets/svg/complaint.svg",
                          height: 18.h,
                          width: 18.w,
                        ),
                        'action': () => {showPopUp(true, context)}
                      },
                      {
                        'title': 'Пожаловаться на неприемлемый контент',
                        'icon': SvgPicture.asset(
                          "assets/svg/complaint.svg",
                          colorFilter: const ColorFilter.mode(
                            Colors.red,
                            BlendMode.srcIn,
                          ),
                          height: 18.h,
                          width: 18.w,
                        ),
                        'action': () => {showPopUp(false, context)}
                      }
                    ],
                    customOffset: [-30.0.w, -30.0.h],
                    width: 317.w,
                    maxWidth: 317.w,
                    dropDownChild: Container(
                      //color: Colors.red,
                      width: 37.w,
                      height: 37.h,
                      padding: EdgeInsets.only(
                          top: 7.h, right: 7.w, left: 6.w, bottom: 6.h),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 25.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 15.w, bottom: 15.h),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: AppColors.blueColor),
                      padding: EdgeInsets.all(3.r),
                      child: SvgPicture.asset(
                        "assets/svg/location.svg",
                        fit: BoxFit.cover,
                        // ignore: deprecated_member_use
                        color: Colors.white,
                      ),
                    ),
                    7.horizontalSpace,
                    Flexible(
                      child: SizedBox(
                        child: CustomText(
                          color: Colors.white,
                          text: address ?? "",
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

void showPopUp(bool isFirstOne, BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setstate) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: const BorderSide(
                  color: AppColors.blueBorder,
                )),
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: isFirstOne
                          ? "Сообщить об ошибке"
                          : "Сообщить о неприемлемом контенте",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    16.verticalSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Center(
                            child: isFirstOne
                                ? SvgPicture.asset(
                                    "assets/svg/complaint.svg",
                                    width: 15.w,
                                    height: 15.h,
                                  )
                                : SvgPicture.asset(
                                    "assets/svg/complaint.svg",
                                    colorFilter: const ColorFilter.mode(
                                      Colors.red,
                                      BlendMode.srcIn,
                                    ),
                                    width: 15.w,
                                    height: 15.h,
                                  ),
                          ),
                        ),
                        10.horizontalSpace,
                        Flexible(
                          child: CustomText(
                            text: isFirstOne
                                ? "Опишите найденную ошибку как можно подробнее. Сообщение будет передано напрямую администрации заведения."
                                : "Ваше сообщение попадёт напрямую разработчикам приложения, а не администрации заведения.Опишите ситуацию максимально подробно",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    16.verticalSpace,
                    SizedBox(
                      //height: 40.h,
                      child: CustomTextField(
                        counterStyle: const TextStyle(
                          height: double.minPositive,
                        ),
                        style: GoogleFonts.raleway(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFeatures: const [FontFeature.liningFigures()],
                        ),
                        counterText: "",
                        cursorColor: AppColors.greyText,
                        controller:
                            isFirstOne ? errorController : complaintController,
                        focusNode: focusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 300,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 8.w),
                        hintText: "Опишите ситуацию",
                      ),
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonColor: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 40.h,
                            onPressed: () {
                              context.popRoute();
                            },
                            text: "Отменить",
                          ),
                        ),
                        5.horizontalSpace,
                        Expanded(
                          child: CustomButton(
                            textColor: Colors.white,
                            buttonColor: AppColors.blueColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 40.h,
                            onPressed: () {},
                            text: "Отправить",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
