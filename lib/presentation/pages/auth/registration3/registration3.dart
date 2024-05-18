// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/custom_textfield.dart';
import 'package:myfit/presentation/pages/auth/registration3/widget/bottom_wave.dart';
import 'package:myfit/presentation/pages/auth/registration3/widget/medium_wave.dart';
import 'package:myfit/presentation/pages/auth/registration3/widget/top_wave.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../infrastructure/models/response/auth_response.dart';

@RoutePage()
class Registration3Screen extends ConsumerStatefulWidget {
  const Registration3Screen({super.key});

  @override
  ConsumerState<Registration3Screen> createState() =>
      _Registration3ScreenState();
}

class _Registration3ScreenState extends ConsumerState<Registration3Screen> {
  TextEditingController cityController = TextEditingController(
      text: LocalStorage.getSelectedCity().isEmpty
          ? ""
          : LocalStorage.getSelectedCity());
  TextEditingController nameController =
      TextEditingController(text: LocalStorage.getUserName());
  FocusNode focusNode = FocusNode();
  FocusNode nameFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  final layerlink = LayerLink();
  bool isNameNotGiven = false;
  bool isCityNotSelected = false;
  City? selectedCity;
  bool isAllFieldsSumbitted = false;
  bool showReplayButton = false;
  bool topGapRemoved = false;
  bool hideButton = false;

  void setSelectedCity(City city) {
    selectedCity = city;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ref.read(settingsProvider.notifier).getListOfCities(context);
  }


  @override
  Widget build(BuildContext context) {
    final event = ref.read(settingsProvider.notifier);
    final height = MediaQuery.of(context).size.height;
    ref.listen(settingsProvider, (previous, next) async{
      if (previous!.dropDownOpened != next.dropDownOpened && !next.dropDownOpened) {
        await Future.delayed(const Duration(milliseconds: 270));
        hideButton = false;
        setState(() {});
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // waves
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: isAllFieldsSumbitted ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: CustomPaint(
                size: Size(400, 180.w),
                painter: TopWave(),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: isAllFieldsSumbitted ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: CustomPaint(
                size: Size(350, 160.w),
                painter: MediumWave(),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: isAllFieldsSumbitted ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: CustomPaint(
                size: Size(400, 70.w),
                painter: BottomWave(),
              ),
            ),
          ),

          // Icons
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 28.h,
            left: isAllFieldsSumbitted ? -30 : 40.w,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(3.r),
              child: SvgPicture.asset(
                "assets/svg/boxing.svg",
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 40.h,
            left: isAllFieldsSumbitted ? -30 : 120.w,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(3.r),
              child: SvgPicture.asset(
                "assets/svg/yoga.svg",
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 135.h,
            right: isAllFieldsSumbitted ? -30 : 40.w,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(3.r),
              child: SvgPicture.asset(
                "assets/svg/cardio.svg",
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 60.h,
            right: isAllFieldsSumbitted ? -30 : 20.w,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(3.r),
              child: SvgPicture.asset(
                "assets/svg/meditation.svg",
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 25.h,
            right: isAllFieldsSumbitted ? -30 : 90.w,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(3.r),
              child: SvgPicture.asset(
                "assets/svg/gym.svg",
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 55.h,
            right: isAllFieldsSumbitted ? -30 : 140.w,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(3.r),
              child: SvgPicture.asset(
                "assets/svg/pool.svg",
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 95.h,
            left: isAllFieldsSumbitted ? -30 : 10.w,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(3.r),
              child: SvgPicture.asset(
                "assets/svg/popa.svg",
              ),
            ),
          ),
          
          
          // main body
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isAllFieldsSumbitted ? 0 : 16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topGapRemoved ? 0.verticalSpace : 89.verticalSpace,
                  Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                      border: Border.all(color: isAllFieldsSumbitted
                            ? Colors.transparent : AppColors.greyBorder,
                      ),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      height: isAllFieldsSumbitted ? height : 132.h,
                      width: double.maxFinite,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isAllFieldsSumbitted
                              ? CustomText(
                                  text: "Добро пожаловать в команду",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                )
                              : const SizedBox.shrink(),
                          isAllFieldsSumbitted ? 25.verticalSpace : 0.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/MY.svg",
                                width: isAllFieldsSumbitted ? 120.w : null,
                              ),
                              5.horizontalSpace,
                              SvgPicture.asset(
                                "assets/svg/FIT.svg",
                                width: isAllFieldsSumbitted ? 120.w : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // creating separate column to hide its content when showing animation
                  !isAllFieldsSumbitted
                      ? Consumer(builder: (context, ref, child) {
                        final dropDownOpened = ref.watch(settingsProvider).dropDownOpened;
                        final notifier = ref.read(settingsProvider.notifier);
                        return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          48.verticalSpace,
                          CustomText(
                            text: "Как к вам обращаться",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          5.verticalSpace,
                          SizedBox(
                            height: 40.h,
                            width: double.maxFinite,
                            child: CustomTextField(
                              isError: isNameNotGiven,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Zа-яА-Я]'),
                                ),
                              ],
                              counterStyle: const TextStyle(height: double.minPositive),
                              counterText: "",
                              maxLength: 16,
                              style: GoogleFonts.raleway(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              controller: nameController,
                              focusNode: nameFocus,
                              onTapOutside: (onTapOutside) {
                                if (nameFocus.hasFocus) {
                                  nameFocus.unfocus();
                                }
                              },
                              onTap: () {
                                if (!nameFocus.hasFocus) {
                                  nameFocus.requestFocus();
                                }
                              },
                              onEditingComplete: () {
                                if (!nameFocus.hasFocus) {
                                  nameFocus.requestFocus();
                                }
                              },
                              maxLines: 1,
                              contentPadding: EdgeInsets.zero.copyWith(left: 10.w),
                              hintText: "Ваше имя",
                            ),
                          ),
                          isNameNotGiven
                              ? Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: CustomText(
                                    text:"Имя должна содержать хотя бы 3 буквы",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                )
                              : const SizedBox(),
                          32.verticalSpace,
                          CustomText(
                            text: "В каком городе искать активности",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          5.verticalSpace,
                          // new dropdown
                          Column(
                            children: [
                              CustomTextField(
                                style: GoogleFonts.raleway(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                onTap: () async{
                                  if (!dropDownOpened) {
                                    notifier.openDropDown();
                                    focusNode.requestFocus();
                                    hideButton = true;
                                  } else {
                                    focusNode.unfocus();
                                    notifier.closeDropDown();
                                  }
                                },
                                isError: isCityNotSelected,
                                readOnly: true,
                                focusNode: focusNode,
                                //hasFocus: dropDownOpened,
                                controller: cityController,
                                hintText:LocalStorage.getSelectedCity().isEmpty ? "Выберите город" : "",
                                suffixIcon: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 300),
                                tween: Tween(begin: 0,end: dropDownOpened ? 1.0 : 0),
                                builder:(BuildContext context, double angle, Widget? child) {
                                  return Transform.rotate(
                                    angle: angle * pi,
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20.sp,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  );
                                },
                              ),
                                contentPadding: EdgeInsets.zero.copyWith(left: 10.w),
                              ),
                              5.verticalSpace,
                              //if(focusNode.hasFocus)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                height: dropDownOpened ? 294.h : 0,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.white,
                                border: Border.all(
                                width: 1.0,
                                color: const Color.fromRGBO(119, 170, 249, 1),
                                ),
                              ),
                               padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                removeBottom: true,
                                child: Consumer(builder: (context, ref, child) {
                                  final listOfCities = ref.watch(settingsProvider).listOfCities;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: listOfCities.length,
                                    itemBuilder: (context, index) {
                                      final currentCity = listOfCities[index];
                                      return _listiles(
                                        currentCity.name ?? "",
                                        () {
                                          cityController.text = currentCity.name ?? "??";
                                          focusNode.unfocus();
                                          setSelectedCity(currentCity);
                                          ref.read(settingsProvider.notifier).closeDropDown();
                                        },
                                      );
                                    },
                                  );
                                }),
                              ),
                            ),
                            ],
                          ),
                          isCityNotSelected
                              ? Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: CustomText(
                                    text: "Выберите город",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          32.verticalSpace,
                      
                          // button
                          Visibility(
                            visible: !hideButton,
                            child: Container(
                              margin: focusNode.hasFocus
                                  ? EdgeInsets.symmetric(horizontal: 3.w)
                                  : EdgeInsets.zero,
                              height: 56.h,
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.15),
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(109, 150, 212, 1),
                                    offset: Offset(0, 15),
                                    blurRadius: 18,
                                    spreadRadius: -15,
                                  ),
                                ],
                              ),
                              child: CustomButton(
                                buttonColor: AppColors.blueColor,
                                textColor: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                onPressed: () async {
                                  if (nameController.text.length > 2 && cityController.text.isNotEmpty) {
                                    if (nameController.text != LocalStorage.getUserName()) {
                                      // if user changed name
                                      await LocalStorage.setUserName(nameController.text);
                                      event.patchName(nameController.text, context);
                                    }
                                    if (cityController.text !=LocalStorage.getSelectedCity()) {
                                      // if user changed city
                                      await LocalStorage.setSelectedCity(cityController.text);
                                      await LocalStorage.setSelectedCityLat(selectedCity?.latitude ?? "");
                                      await LocalStorage.setSelectedCityLon(selectedCity?.longitude ?? "");
                                      event.patchCity(selectedCity, context);
                                    }
                                    isAllFieldsSumbitted = true;
                                    topGapRemoved = true;
                                    setState(() {});
                                    await Future.delayed(const Duration(milliseconds: 400));
                                    context.router.push(const Registration4Route());
                                  } else {
                                    if (nameController.text.length < 2) {
                                      isNameNotGiven = true;
                                      setState(() {});
                                    }
                                    if (cityController.text.isEmpty) {
                                      isCityNotSelected = true;
                                      setState(() {});
                                    }
                                  }
                                },
                                text: "Продолжить",
                              ),
                            ),
                          ),
                        ],
                      );
                      },)
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),

          
        ],
      ),
    );
  }
}

Widget _listiles(
  String name,
  void Function()? onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(left: 5.w, bottom: 10.h),
      child: CustomText(
        text: name,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
