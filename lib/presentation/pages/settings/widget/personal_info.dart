// ignore_for_file: use_build_context_synchronously
import 'dart:ui';
import 'package:activity/application/settings/settings_notifier.dart';
import 'package:activity/application/settings/settings_provider.dart';
import 'package:activity/application/settings/settings_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/custom_textformfield.dart';
import 'package:activity/presentation/components/edit_button.dart';
import 'package:activity/presentation/pages/settings/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfo extends StatefulWidget {
  final SettingsNotifier event;
  final SettingsState state;
  const PersonalInfo({super.key, required this.event, required this.state});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  bool newDataAdded = false;
  bool isCodeError = false;
  late FocusNode cityFocusNode;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController pinputController;

  @override
  void initState() {
    super.initState();
    cityFocusNode = FocusNode();
    phoneController = TextEditingController(
        text: widget.state.phoneNumber.isEmpty
            ? LocalStorage.getPhoneNumber()
            : widget.state.phoneNumber);
    emailController = TextEditingController();
    pinputController = TextEditingController();

    phoneController.addListener(() {
      if (phoneController.text.length == 12 &&
          phoneController.text != LocalStorage.getPhoneNumber()) {
        newDataAdded = true;
        setState(() {});
      } else {
        newDataAdded = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    cityFocusNode.dispose();
    phoneController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("city ${widget.state.selectedCity ?? ""}");
      print("phone ${widget.state.phoneNumber}");
      print("name ${widget.state.userName}");
      print(LocalStorage.getPhoneNumber());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Персональные данные",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        10.verticalSpace,
        CustomCard(
          width: double.maxFinite,
          child: Column(
            children: [
              // top row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // photo
                  SizedBox(
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundColor: AppColors.blueColor,
                      child: Padding(
                        padding: EdgeInsets.all(2.r),
                        child: ClipOval(
                            child: Image.asset(
                          AppConstants.cristianBale,
                          fit: BoxFit.cover,
                        )
                            /* CachedNetworkImage(
                                imageUrl: AppConstants.owlNetworkImage,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return const SizedBox();
                                },
                              ), */
                            ),
                      ),
                    ),
                  ),
                  18.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.verticalSpace,
                      Row(
                        children: [
                          CustomText(
                            text: widget.state.userName.isEmpty
                                ? " widget.state.userName.isEmpty"
                                : widget.state.userName,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          3.horizontalSpace,
                          if (widget.state.userLastName.isNotEmpty)
                            CustomText(
                              text: widget.state.userLastName,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                      CustomText(
                        text: LocalStorage.getSelectedCity(),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      5.verticalSpace,
                    ],
                  ),
                  const Spacer(),
                  EditButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            elevation: 0,
                            insetPadding:
                                EdgeInsets.symmetric(horizontal: 16.w),
                            child: Consumer(builder: (context, ref, child) {
                              final stateConsumer = ref.watch(settingsProvider);
                              final eventConsumer =
                                  ref.read(settingsProvider.notifier);
                              return PopupBody(
                                event: eventConsumer,
                                state: stateConsumer,
                              );
                            }),

                            /*  */
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              16.verticalSpace,
              // bottom row
              Row(
                children: [
                  chipsLikeContainer(
                    widget.state.age == "null" ? "0" : widget.state.age,
                    "лет",
                    context,
                  ),
                  20.horizontalSpace,
                  chipsLikeContainer(
                    widget.state.weight == "null" ? "0" : widget.state.weight,
                    "кг",
                    context,
                  ),
                  20.horizontalSpace,
                  chipsLikeContainer(
                    widget.state.height == "null" ? "0" : widget.state.height,
                    "см",
                    context,
                  ),
                ],
              ),
            ],
          ),
        ),
        10.verticalSpace,

        // phone and email
        CustomCard(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Телефон",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                EditButton(
                  newDataAdded: newDataAdded,
                  editingEnabled: widget.state.isPhoneEditModeEnabled,
                  onTap: () {
                    if (widget.state.isPhoneEditModeEnabled) {
                      if (phoneController.text !=
                          LocalStorage.getPhoneNumber()) {
                        phoneController.text = LocalStorage.getPhoneNumber();
                        setState(() {});
                      }
                      if (newDataAdded) {
                        newDataAdded = false;
                        setState(() {});
                      }
                      widget.event.closeEditingPhone();
                    } else {
                      widget.event.enableEditingPhone();
                    }
                  },
                ),
              ],
            ),
            10.verticalSpace,
            SizedBox(
              height: 40.h,
              child: CustomTextFormField(
                onChanged: (value) {
                  phoneController.text = value;
                  setState(() {});
                },
                onEditingComplete: () {
                  if (newDataAdded && phoneController.text.length == 12) {
                    // hide keyboard
                    FocusScope.of(context).unfocus();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ChangingPhoneDialog(
                          newPhoneNumber: phoneController.text,
                          undoAction: () {
                            phoneController.text =
                                LocalStorage.getPhoneNumber();
                            newDataAdded = false;
                            setState(() {});
                            widget.event.closeEditingPhone();
                            context.router.pop();
                          },
                          onSuccessfulChange: () async {
                            widget.event.closeEditingPhone();
                            newDataAdded = false;
                            setState(() {});
                            context.router.pop();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
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
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.done,
                                                  color: AppColors.blueColor,
                                                ),
                                                5.horizontalSpace,
                                                CustomText(
                                                  text:
                                                      "Номер был успешно изменён",
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                )
                                              ],
                                            ),
                                            16.verticalSpace,
                                            CustomButton(
                                              onPressed: () {
                                                context.router.pop();
                                              },
                                              text: "Спасибо",
                                              height: 40.h,
                                              width: 110.w,
                                              buttonColor: AppColors.blueColor,
                                              textColor: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                        );
                      },
                    );
                  }
                },
                keyboardType: TextInputType.phone,
                //inputFormatters: [AppValidators().phoneMask],
                contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
                readOnly: !widget.state.isPhoneEditModeEnabled,
                controller: phoneController,
                dontShowBorders: !widget.state.isPhoneEditModeEnabled,
                suffixIcon: newDataAdded && phoneController.text.length == 12
                    ? InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ChangingPhoneDialog(
                                newPhoneNumber: phoneController.text,
                                undoAction: () {
                                  phoneController.text =
                                      LocalStorage.getPhoneNumber();
                                  newDataAdded = false;
                                  setState(() {});
                                  widget.event.closeEditingPhone();
                                  context.router.pop();
                                },
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 2.w),
                          child: Container(
                            margin: EdgeInsets.all(5.r).copyWith(),
                            width: 24.w,
                            //height: 24.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: AppColors.blueColor,
                            ),
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 18.r,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                maxLines: 1,
                maxLength: 12,
              ),
            ),
            32.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "E-mail",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                EditButton(onTap: () {}),
              ],
            ),
            10.verticalSpace,
            CustomText(
              text: "supa-starrr@vinewood.com",
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        )),
      ],
    );
  }
}

Widget chipsLikeContainer(
  String firstText,
  String seconsText,
  BuildContext context,
) {
  return InkWell(
    onTap: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Consumer(builder: (context, ref, child) {
              final stateConsumer = ref.watch(settingsProvider);
              final eventConsumer = ref.read(settingsProvider.notifier);
              return PopupBody(
                event: eventConsumer,
                state: stateConsumer,
              );
            }),
            /*  */
          );
        },
      );
    },
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.fadedBlueBorder, width: 1.w),
        color: AppColors.backgroundColor,
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: firstText,
                style: GoogleFonts.raleway(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blueText,
                  fontFeatures: const [FontFeature.liningFigures()],
                ),
              ),
              WidgetSpan(
                  child: SizedBox(
                width: 2.w,
              )),
              TextSpan(
                text: seconsText,
                style: GoogleFonts.raleway(
                  fontSize: 14.sp,
                  color: AppColors.blueText,
                  fontWeight: FontWeight.w400,
                  fontFeatures: const [FontFeature.liningFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
