// ignore_for_file: use_build_context_synchronously
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/settings/settings_notifier.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/application/settings/settings_state.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/custom_textfield.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/presentation/components/dummy_data.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import '../../../../infrastructure/models/response/auth_response.dart';

class PopupBody extends ConsumerStatefulWidget {
  final SettingsNotifier event;
  final SettingsState state;
  const PopupBody({super.key, required this.event, required this.state});

  @override
  ConsumerState<PopupBody> createState() => _PopupBodyState();
}

class _PopupBodyState extends ConsumerState<PopupBody> {
  GlobalKey sizedBoxKey = GlobalKey();
  City? selectedCity;
  bool isNameWrong = false;
  bool isSurnameWrong = false;
  bool isBirhdayWrong = false;
  bool isGenderWrong = false;
  bool isCityWrong = false;
  String birthdayErrorMes = "";
  final FocusNode focusNode = FocusNode();
  final FocusNode genderFocusNode = FocusNode();
  late TextEditingController cityController;
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController genderController;
  late TextEditingController birthdayController;
  final dateInputFormatter = MaskTextInputFormatter(
    mask: '##.##.####',
    filter: {"#": RegExp(r'[0-9]')},
    initialText: LocalStorage.getUserBirthday().isEmpty ? "" :  AppHelpers.getBirthdayLikeInApp(LocalStorage.getUserBirthday()),
    type: MaskAutoCompletionType.eager
  );
  @override
  void initState() {
    super.initState();
    cityController =
        TextEditingController(text: LocalStorage.getSelectedCity());
    nameController = TextEditingController(text: LocalStorage.getUserName());
    lastNameController = TextEditingController(
        text: LocalStorage.getUserLastName().isEmpty ? "" : LocalStorage.getUserLastName());
    ageController = TextEditingController(
        text: LocalStorage.getAge().isEmpty ? "" : LocalStorage.getAge());
    weightController = TextEditingController(
        text: LocalStorage.getWeight().isEmpty ? "" : LocalStorage.getWeight());
    heightController = TextEditingController(
        text: LocalStorage.getHeight().isEmpty ? "" : LocalStorage.getHeight());
    genderController = TextEditingController(text: LocalStorage.getGender());
    birthdayController = TextEditingController(
        text: LocalStorage.getUserBirthday().isEmpty ? "" : AppHelpers.getBirthdayLikeInApp(LocalStorage.getUserBirthday()));
    
  }

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    birthdayController.dispose();
  }

  void setSelectedCity(City? city) {
    selectedCity = city;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime whenLastChangedPhoto = (AppHelpers.gePhotoAccessTime(widget.state.user?.changePhotoDate));
    final DateTime whenAccessShouldOpen = whenLastChangedPhoto.add(const Duration(days: 7));
    final bool canChangePhoto =DateTime.now().isAfter(whenAccessShouldOpen) ; 
    final String formattedString = widget.event.formatDuration(whenAccessShouldOpen.difference(DateTime.now()));
    return CustomCard(
      borderColor: Colors.transparent,
      width: double.maxFinite,
      height: !canChangePhoto ? 575.h + ((isBirhdayWrong || isNameWrong || isSurnameWrong) ? 50.h : 0) : 
        618.h + ((isBirhdayWrong || isNameWrong || isSurnameWrong) ? 50.h : 0),
      child: Stack(
        children: [
          // name and last name row
          Positioned(
            top: 0,
            child: Row(
              children: [
                // имя
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Ваше имя",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.state.missingInfo.contains("firstName") || isNameWrong
                          ? AppColors.redBorder : Colors.black,
                    ),
                    5.verticalSpace,
                    SizedBox(
                      height: 40.h,
                      width: 150.w, 
                      child: CustomTextField(
                        style: GoogleFonts.raleway(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zа-яА-Я]')),
                        ],
                        textCapitalization: TextCapitalization.sentences,
                        isError: isNameWrong || widget.state.missingInfo.contains("firstName"),
                        hasFocus: true,
                        cursorColor: AppColors.greyText,
                        maxLength: 32,
                        contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
                        counterStyle: const TextStyle(
                          height: double.minPositive,
                        ),
                        counterText: "",
                        controller: nameController,
                        hintText: LocalStorage.getUserName().isEmpty ? "Имя" : "",
                        onChanged: (val) {
                          if (val.trim().length >= 2 && isNameWrong) {
                            isNameWrong = false;
                            setState(() {});
                          }
                          if (val.trim().length < 2 && !isNameWrong) {
                            isNameWrong = true;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
                9.horizontalSpace,
                // Фамилия
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Фамилия",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.state.missingInfo.contains("lastName") || isSurnameWrong
                          ? AppColors.redBorder : Colors.black,
                    ),
                    5.verticalSpace,
                    SizedBox(
                      width: 150.w,
                      height: 40.h,
                      child: CustomTextField(
                        style: GoogleFonts.raleway(fontSize: 14.sp, fontWeight: FontWeight.w400),
                        contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
                        maxLength: 32,
                        textCapitalization: TextCapitalization.sentences,
                        counterStyle: const TextStyle(height: double.minPositive),
                        counterText: "",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zа-яА-Я]')),
                        ],
                        onChanged: (val){
                          if (val.trim().length >= 2 && isSurnameWrong) {
                            isSurnameWrong = false;
                            setState(() {});
                          }
                          if (val.trim().length < 2 && !isSurnameWrong) {
                            isSurnameWrong = true;
                            setState(() {});
                          }
                        },
                        controller: lastNameController,
                        isError: widget.state.missingInfo.contains("lastName") || isSurnameWrong,
                        hintText: LocalStorage.getUserLastName().isEmpty
                            ? "Фамилия" : "",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // weight, height row
          Positioned(
            top: 235.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* // возраст
                userParamsField(
                  text: "Возраст",
                  controller: ageController,
                  isError: widget.state.missingInfo.contains("age"),
                ), */
                //SizedBox(width: 15.w),
                // вес
                userParamsField(
                  text: "Вес, кг",
                  controller: weightController,
                  isError: widget.state.missingInfo.contains("weight"),
                ),
                SizedBox(width: 9.w),
                // рост
                userParamsField(
                  text: "Рост, см",
                  controller: heightController,
                  isError: widget.state.missingInfo.contains("height"),
                ),
              ],
            ),
          ),

          // avatar
          Positioned(
              top: 315.h,
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Аватар",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  5.verticalSpace,
                  SizedBox(
                    //color: Colors.red,
                    height: widget.state.avatar.isEmpty ? null : 83.h,
                    child: widget.state.avatar.isEmpty
                        ? Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  await widget.event.pickImageFromGallery(context);
                                },
                                child: CircleAvatar(
                                  radius: 40.r,
                                  backgroundColor: AppColors.backgroundColor,
                                  child:  Center(
                                    child: widget.state.isPhotoUploading
                                        ? const CupertinoActivityIndicator()
                                        : const Icon(
                                            Icons.add,
                                            color: AppColors.blueBorder,
                                          ),
                                  ),
                                ),
                              ),
                              9.horizontalSpace,
                              CustomButton(
                                height: 36.h,
                                width: 220.w,
                                borderColor: AppColors.fadedBlueBorder,
                                buttonColor: AppColors.backgroundColor,
                                fontSize: 14.sp,
                                onPressed: () async {
                                  await widget.event.pickImageFromGallery(context);
                                },
                                text: "Добавить фотографию",
                              )
                            ],
                          )
                        : Row(
                            children: [
                              CircleAvatar(
                                radius: 40.r,
                                backgroundColor: AppColors.backgroundColor,
                                child: widget.state.isPhotoUploading
                                    ? const CupertinoActivityIndicator()
                                    : CircleAvatar(
                                        radius: 38.r,
                                        backgroundImage: NetworkImage("${AppConstants.baseUrl}image/${widget.state.avatar}"),
                                        onBackgroundImageError:
                                            (exception, stackTrace) {
                                          debugPrint(exception.toString());
                                        },
                                      ),
                              ),
                              9.horizontalSpace,
                              if (canChangePhoto)
                                CustomButton(
                                  height: 36.h,
                                  width: 220.w,
                                  fontSize: 14.sp,
                                  borderColor: AppColors.fadedBlueBorder,
                                  onPressed: () async {
                                    await widget.event.pickImageFromGallery(context);
                                  },
                                  text: "Заменить",
                                ),
                              if (!canChangePhoto)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 220.w,
                                      //color: Colors.red,
                                      child: CustomText(
                                        text:"Фотографию можно обновлять не чаще раза в неделю.",
                                        fontSize: 16.sp,
                                        height: 1.1,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    2.verticalSpace,
                                    RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Осталось: ",
                                          style: GoogleFonts.raleway(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              height: 1.1),
                                        ),
                                        TextSpan(
                                          text: formattedString,
                                          style: GoogleFonts.raleway(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            height: 1.1,
                                            fontFeatures: const [
                                              FontFeature.liningFigures()
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                            ],
                          ),
                  ),
                ],
              )),

          // внимание
          Positioned(
            top: 440.h,
            child: SizedBox(
              width: 310.w,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Внимание!",
                        style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        )),
                    WidgetSpan(child: SizedBox(width: 3.w)),
                    TextSpan(
                      text:"Администратор на входе будет сверяться с этим фото, чтобы вас пропустить",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (canChangePhoto)
            Positioned(
              top: 485.h,
              child: SizedBox(
                width: 310.w,
                child: CustomText(
                  text: "Фотографию можно обновлять не чаще раза в неделю",
                  fontSize: 16.sp,
                  height: 1.1,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          // city
          Positioned(
            top: 155.h,
            child: CustomText(
              text: "В каком городе искать активности",
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: widget.state.missingInfo.contains("city")
                  ? AppColors.redBorder : Colors.black,
            ),
          ),
          Positioned(
            top: 185.h,
            child: Consumer(
              builder: (context, ref, child) {
                final dropDownOpened =ref.watch(settingsProvider).dropDownOpened;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40.h,
                      width: 309.w,
                      child: CustomTextField(
                        isError: widget.state.missingInfo.contains("city"),
                        focusNode: focusNode,
                        style: GoogleFonts.raleway(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
                        contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
                        onTap: () async {
                          if (!dropDownOpened) {
                            widget.event.openDropDown();
                            focusNode.requestFocus();
                          } else {
                            focusNode.unfocus();
                            widget.event.closeDropDown();
                          }
                        },
                        suffixIcon: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 300),
                          tween: Tween(begin: 0, end: dropDownOpened ? 1.0 : 0),
                          builder: (BuildContext context, double angle,
                              Widget? child) {
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
                        readOnly: true,
                        controller: cityController,
                        hintText: LocalStorage.getSelectedCity().isEmpty ? "Выберите город" : "",
                      ),
                    ),
                    5.verticalSpace,
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: dropDownOpened ? 260.h : 0,
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
                          return SizedBox(
                            width: 275.w,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: listOfCities.length,
                              itemBuilder: (context, index) {
                                final currentCity = listOfCities[index];
                                return _listiles(
                                  currentCity.name ?? "",
                                  () {
                                    cityController.text = currentCity.name ?? "??";
                                    isCityWrong = false;
                                    focusNode.unfocus();
                                    setSelectedCity(currentCity);
                                    ref.read(settingsProvider.notifier).closeDropDown();
                                  },
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // gender and birthday
          Positioned(
            top: 77.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Пол",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.state.missingInfo.contains("gender")
                          ? AppColors.redBorder
                          : Colors.black,
                    ),
                    5.verticalSpace,
                    Consumer(
                      builder: (context, ref, child) {
                        final genderDropDownOpened =
                            ref.watch(settingsProvider).genderDropDownOpened;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // gender field
                            SizedBox(
                              height: 40.h,
                              width: 150.w,
                              child: CustomTextField(
                                hintText: LocalStorage.getGender().isEmpty
                                    ? "Не указано" : "",
                                isError: widget.state.missingInfo.contains("gender"),
                                focusNode: genderFocusNode,
                                style: GoogleFonts.raleway(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                                contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
                                onTap: () async {
                                  if (!genderDropDownOpened) {
                                    widget.event.openGenderDropDown();
                                    genderFocusNode.requestFocus();
                                  } else {
                                    genderFocusNode.unfocus();
                                    widget.event.closeGenderDropDown();
                                  }
                                },
                                suffixIcon: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 300),
                                  tween: Tween(
                                      begin: 0,
                                      end: genderDropDownOpened ? 1.0 : 0),
                                  builder: (BuildContext context, double angle,
                                      Widget? child) {
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
                                readOnly: true,
                                controller: genderController,
                              ),
                            ),
                            // overlay
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: genderDropDownOpened ? 80.h : 0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.white,
                                border: Border.all(
                                  width: 1.0,
                                  color: const Color.fromRGBO(119, 170, 249, 1),
                                ),
                              ),
                              margin: EdgeInsets.only(top: 3.h),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 16.w),
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                removeBottom: true,
                                child: Consumer(builder: (context, ref, child) {
                                  return SizedBox(
                                    width: 120.w,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: DummyData().genders.length,
                                      itemBuilder: (context, index) {
                                        final current = DummyData().genders[index];
                                        return _listiles(
                                          current,
                                          () {
                                            genderController.text = current;
                                            isGenderWrong = false;
                                            genderFocusNode.unfocus();
                                            widget.event.closeGenderDropDown();
                                            setState(() {});
                                          },
                                        );
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                7.5.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Дата рождения",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.state.missingInfo.contains("birthdayDate") || isBirhdayWrong
                          ? AppColors.redBorder
                          : Colors.black,
                    ),
                    5.verticalSpace,
                    // gneder field
                    SizedBox(
                      height: 40.h,
                      width: 150.w,
                      child: CustomTextField(
                        inputFormatters: [dateInputFormatter],
                        hintText: "18.11.2003",
                        isError: widget.state.missingInfo.contains("birthdayDate") || isBirhdayWrong,
                        controller: birthdayController,
                        keyboardType: TextInputType.datetime,
                        onChanged: (value) {
                          birthdayErrorMes = AppHelpers.getBirthdayErrorMes(value);
                          setState(() {});
                          if (value.length == 10) {
                            final int age = AppHelpers.getYearFromBirthday(
                              AppHelpers.getBirthdayLikeInServer(dateInputFormatter.getMaskedText()));
                            if (age > 1 && age < 100) {
                              if (isBirhdayWrong) {
                                isBirhdayWrong = false;
                                setState(() {});
                              }
                            } else {
                              if (!isBirhdayWrong) {
                                isBirhdayWrong = true;
                                setState(() {});
                              }
                            }
                          }
                        },
                        //focusNode: genderFocusNode,
                        style: GoogleFonts.raleway(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFeatures: const [FontFeature.liningFigures()]),
                        contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // buttons
          Positioned(
            top: !canChangePhoto ? 490.h : 535.h,
            child: Consumer(builder: (context, ref, child) {
              final mapEvent = ref.watch(mapProvider.notifier);
              final cityDropDownOpened = ref.watch(settingsProvider).dropDownOpened;
              final genderDropDownOpened = ref.watch(settingsProvider).genderDropDownOpened;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      width: 150.w,
                      height: 40.h,
                      fontSize: 14.sp,
                      buttonColor: Colors.white,
                      onPressed: () {
                        if (cityDropDownOpened) {
                          ref.read(settingsProvider.notifier).closeDropDown();
                        }
                        if (genderDropDownOpened) {
                          ref.read(settingsProvider.notifier).closeGenderDropDown();
                        }
                        birthdayController.clear();
                        dateInputFormatter.clear(); 
                        context.popRoute();
                      },
                      text: "Отменить",
                    ),
                    9.horizontalSpace,
                    CustomButton(
                      showProgress: widget.state.isloading,
                      width: 150.w,
                      height: 40.h,
                      fontSize: 14.sp,
                      buttonColor: AppColors.blueColor,
                      borderColor: AppColors.blueBorder,
                      textColor: Colors.white,
                      onPressed: () async {
                          final String birthdaySendToServer = birthdayController.text.length == 10 ? 
                            AppHelpers.getBirthdayLikeInServer(birthdayController.text) : "";
                          final bool birthdayChanged = birthdayController.text.length == 10 && !isBirhdayWrong && 
                            LocalStorage.getUserBirthday() != birthdaySendToServer && birthdaySendToServer.isNotEmpty;
                            /* if (isBirhdayWrong || isNameWrong || isSurnameWrong || birthdayController.text.length < 10) {
                              if (!isBirhdayWrong && birthdayController.text.length < 10 ) {
                                isBirhdayWrong = true;
                                setState(() {});
                              }
                            } */
                           if (nameController.text.trim().length < 2 || lastNameController.text.trim().length <2 || 
                                birthdayController.text.length < 10 || cityController.text.isEmpty || genderController.text.isEmpty) {
                             if (!isBirhdayWrong && birthdayController.text.length < 10 ) {
                                birthdayErrorMes = AppHelpers.getBirthdayErrorMes(birthdayController.text.trim());
                                isBirhdayWrong = true; 
                              }
                              if (nameController.text.trim().length < 2 && !isNameWrong) {
                                isNameWrong = true;
                              }
                              if (lastNameController.text.trim().length < 2 && !isSurnameWrong) {
                                isSurnameWrong = true;
                              }
                              if (cityController.text.isEmpty && !isCityWrong) {
                                isCityWrong = true;
                              }
                              if (genderController.text.isEmpty && !isGenderWrong) {
                                isGenderWrong = true;
                              }
                              setState(() {});
                           } else{
                            // check whether user added new data
                              if (LocalStorage.getUserName() != nameController.text.trim()) {
                                await widget.event.patchName(nameController.text.trim(), context);
                              }
                              if (LocalStorage.getUserLastName() != lastNameController.text.trim()) {
                                await widget.event.patchLastname(lastNameController.text.trim(), context);
                              }
                              if (LocalStorage.getSelectedCity() != cityController.text) {
                                await widget.event.patchCity(selectedCity, context);
                                await mapEvent.setLocationFromSelectedCity();
                              }
                              if (birthdayChanged) {
                                await widget.event.patchBirthday(birthdaySendToServer, context);
                              }
                              /* if (LocalStorage.getAge() != ageController.text) {
                                await widget.event.patchAge(ageController.text, context);
                              } */
                              if (LocalStorage.getWeight() != weightController.text) {
                                await widget.event.patchWeight(weightController.text, context);
                              }
                              if (LocalStorage.getHeight() != heightController.text) {
                                await widget.event.patchHeight(heightController.text, context);
                              }
                              if (LocalStorage.getGender() != genderController.text) {
                                await widget.event.patchGender(genderController.text, context);
                              }
                              if (widget.state.missingInfo.isNotEmpty) {
                                widget.event.getUser(context);
                              }
                              if (cityDropDownOpened) {
                                ref.read(settingsProvider.notifier).closeDropDown();
                              }
                              if (genderDropDownOpened) {
                                ref.read(settingsProvider.notifier).closeGenderDropDown();
                              }
                              context.popRoute();
                              birthdayController.clear();
                              dateInputFormatter.clear(); 
                              }
                          },
                          text: "Сохранить",
                        ),
                  ],),
                    (isBirhdayWrong || isNameWrong || isSurnameWrong || isGenderWrong || isCityWrong) ? 8.verticalSpace : 0.verticalSpace,
                    if(isBirhdayWrong || isNameWrong || isSurnameWrong || isGenderWrong || isCityWrong)
                    SizedBox(
                      width: 310.w,
                      child: InterText(
                        text: (isNameWrong && isSurnameWrong) ? "Имя и Фамилия должны содержать хотя бы по 2 буквы" : isNameWrong ? 
                        "Имя должно содержать хотя бы 2 буквы" : isSurnameWrong ? "Фамилия должна содержать хотя бы 2 буквы" : isGenderWrong ? "Выберите пол" : 
                          isCityWrong ? "Выберите город" : birthdayErrorMes,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.redText,
                      ),
                    ),
                ],
              );
            
            },),
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
  return InkWell(
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

void showConfirmationDialog(BuildContext context, void Function()? onConfirm) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "Фото профиля будет удалено!",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: CustomButton(
                          onPressed: () {
                            context.router.pop();
                          },
                          text: "Назад",
                          height: 40.h,
                          buttonColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        flex: 6,
                        child: CustomButton(
                          onPressed: onConfirm,
                          text: "Подтвердить",
                          height: 40.h,
                          buttonColor: AppColors.blueColor,
                          textColor: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}

Widget userParamsField(
    {required String text, TextEditingController? controller, bool isError = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomText(
        text: text,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: isError ? AppColors.redBorder : Colors.black,
      ),
      5.verticalSpace,
      SizedBox(
        width: 150.w,
        height: 40.h,
        child: CustomTextField(
          isError: isError,
          style: GoogleFonts.raleway(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            fontFeatures: const [FontFeature.liningFigures()],
          ),
          keyboardType: TextInputType.number,
          controller: controller,
          counterStyle: const TextStyle(height: double.minPositive),
          counterText: "",
          maxLines: 1,
          maxLength: 3,
          contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
        ),
      ),
    ],
  );
}

