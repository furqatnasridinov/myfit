// ignore_for_file: use_build_context_synchronously
import 'dart:math';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
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
      text: LocalStorage.getSelectedCity().isEmpty ? "" : LocalStorage.getSelectedCity());
  TextEditingController nameController = TextEditingController(text: LocalStorage.getUserName());
  TextEditingController surNameController = TextEditingController(text: LocalStorage.getUserLastName());
  FocusNode focusNode = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode surNameFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  final layerlink = LayerLink();
  bool isNameNotGiven = false;
  bool isSurNameNotGiven = false;
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

          // bottom  Icons
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
            padding: EdgeInsets.symmetric(horizontal:  16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  89.verticalSpace,
                  Hero(
                    tag: AppConstants.registration3Hero,
                    child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/svg/myfitNew.svg",
                      ),
                    ),
                  ),
                  40.verticalSpace,
                  CustomText(
                    text: "Данные необходимы для посещения заведений",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                    Consumer(builder: (context, ref, child) {
                        final dropDownOpened = ref.watch(settingsProvider).dropDownOpened;
                        final notifier = ref.read(settingsProvider.notifier);
                        return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          48.verticalSpace,
                          Row(
                            children: [
                              // name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Имя",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    5.verticalSpace,
                                    // name textfield
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
                                        counterStyle: const TextStyle(
                                            height: double.minPositive),
                                        counterText: "",
                                        maxLength: 16,
                                        style: GoogleFonts.raleway(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        controller: nameController,
                                        focusNode: nameFocus,
                                        onChanged: (val) {
                                          if (val.trim().length > 2 && isNameNotGiven) {
                                            isNameNotGiven = false;
                                            setState(() {});
                                          }
                                        },
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
                                        contentPadding:
                                            EdgeInsets.zero.copyWith(left: 10.w),
                                        hintText: "Введите имя",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              5.horizontalSpace,
                              // surName
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Фамилия",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    5.verticalSpace,
                                    // surName textfield
                                    SizedBox(
                                      height: 40.h,
                                      width: double.maxFinite,
                                      child: CustomTextField(
                                        isError: isSurNameNotGiven,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Zа-яА-Я]'),
                                          ),
                                        ],
                                        counterStyle: const TextStyle(
                                            height: double.minPositive),
                                        counterText: "",
                                        maxLength: 16,
                                        style: GoogleFonts.raleway(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        controller: surNameController,
                                        focusNode: surNameFocus,
                                        onChanged: (val) {
                                          if (val.trim().length > 2 && isSurNameNotGiven) {
                                            isSurNameNotGiven = false;
                                            setState(() {});
                                          }
                                        },
                                        onTapOutside: (onTapOutside) {
                                          if (surNameFocus.hasFocus) {
                                            surNameFocus.unfocus();
                                          }
                                        },
                                        onTap: () {
                                          if (!surNameFocus.hasFocus) {
                                            surNameFocus.requestFocus();
                                          }
                                        },
                                        onEditingComplete: () {
                                          if (!surNameFocus.hasFocus) {
                                            surNameFocus.requestFocus();
                                          }
                                        },
                                        maxLines: 1,
                                        contentPadding:
                                            EdgeInsets.zero.copyWith(left: 10.w),
                                        hintText: "Введите фамилию",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          isNameNotGiven || isSurNameNotGiven
                              ? Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: CustomText(
                                    text: getErrorMes(nameController.text, surNameController.text),
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
                                      color: Colors.black.withOpacity(0.5),
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
                                          if (isCityNotSelected) {
                                            isCityNotSelected = false;
                                           // setState(() {});
                                          }
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
                                borderColor: AppColors.blueBorder,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                onPressed: () async {
                                  if (nameController.text.length > 2 && cityController.text.isNotEmpty && surNameController.text.length > 2) {
                                    if (nameController.text != LocalStorage.getUserName()) {
                                      // if user changed name
                                      await LocalStorage.setUserName(nameController.text);
                                      event.patchName(nameController.text, context);
                                    }
                                    if (surNameController.text != LocalStorage.getUserLastName()) {
                                      // if user changed surname
                                      await LocalStorage.setUserLastName(surNameController.text);
                                      event.patchLastname(surNameController.text, context);
                                    }
                                    if (cityController.text !=LocalStorage.getSelectedCity()) {
                                      // if user changed city
                                      await LocalStorage.setSelectedCity(cityController.text);
                                      await LocalStorage.setSelectedCityLat(selectedCity?.latitude ?? "");
                                      await LocalStorage.setSelectedCityLon(selectedCity?.longitude ?? "");
                                      event.patchCity(selectedCity, context);
                                    }
                                    isAllFieldsSumbitted = true;
                                    setState(() {});
                                    await Future.delayed(const Duration(milliseconds: 200));
                                    context.router.push(const Registration4Route());
                                  } else {
                                    if (nameController.text.length < 2) {
                                      isNameNotGiven = true;
                                      setState(() {});
                                    }
                                    if (surNameController.text.length < 2) {
                                      isSurNameNotGiven = true;
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
                    
                ],
              ),
            ),
          ),

           /* // cloud 1 
          Positioned(
            top: 117.h,
            left: 0.w,
            child: SvgPicture.asset(
              "assets/svg/cloud1.svg",
             /*  width: 90.w,
              height: 60.h, */
              )),

          // cloud 2
          Positioned(
            top: 60.h,
            right: 0.w,
            child: SvgPicture.asset(
              "assets/svg/cloud2.svg",
              /* width: 90.w,
              height: 65.h, */
              )),

          // cloud 3
          Positioned(
            top: 160.h,
            right: 30.w,
            child: SvgPicture.asset(
              "assets/svg/cloud3.svg",
              /* width: 90.w,
              height: 60.h, */
              )), */
          
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

String getErrorMes(String name, String surName){
  if (name.length <2 && surName.length < 2) {
    return "Имя и фамилия должны содержать хотя бы 3 буквы";
  } else if (name.length < 2) {
    return "Имя должно содержать хотя бы 3 буквы";
  } else if (surName.length < 2) {
    return "Фамилия должна содержать хотя бы 3 буквы";
  } else {
    return "Введите данные корректно";
    
  }
}