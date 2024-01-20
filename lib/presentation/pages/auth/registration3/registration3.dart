// ignore_for_file: use_build_context_synchronously

import 'package:activity/application/settings/settings_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/custom_textfield.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
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
  OverlayEntry? entry;
  City? selectedCity;

  void setSelectedCity(City city) {
    selectedCity = city;
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          offset: Offset(-16, 50.h),
          link: layerlink,
          child: Material(
            color: Colors.transparent,
            child: TapRegion(
              child: Container(
                height: 294.h,
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                  border: Border.all(
                    width: 1.0,
                    color: const Color.fromRGBO(119, 170, 249, 1),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                child: Column(children: [
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: Consumer(builder: (context, ref, child) {
                        final state = ref.watch(settingsProvider);

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.listOfCities.length,
                          itemBuilder: (context, index) {
                            final currentCity = state.listOfCities[index];
                            return _listiles(
                              currentCity.name ?? "",
                              () {
                                cityController.text = currentCity.name ?? "??";
                                focusNode.unfocus();
                                setSelectedCity(currentCity);
                                setState(() {});
                              },
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  void initState() {
    super.initState();
    ref.read(settingsProvider.notifier).getListOfCities(context);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final event = ref.read(settingsProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // main body
            Form(
              key: formKey,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          counterStyle: const TextStyle(
                            height: double.minPositive,
                          ),
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
                                text: "Имя должна содержать хотя бы 3 буквы",
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
                      SizedBox(
                        height: 40.h,
                        width: double.maxFinite,
                        child: CompositedTransformTarget(
                          link: layerlink,
                          child: CustomTextField(
                            style: GoogleFonts.raleway(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            onTap: () {
                              if (!focusNode.hasFocus) {
                                focusNode.requestFocus();
                                setState(() {});
                              } else {
                                focusNode.unfocus();
                              }
                            },
                            isError: isCityNotSelected,
                            readOnly: true,
                            focusNode: focusNode,
                            controller: cityController,
                            hintText: LocalStorage.getSelectedCity().isEmpty
                                ? "Выберите город"
                                : "",
                            suffixIcon: Icon(
                              focusNode.hasFocus
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 23.r,
                            ),
                            contentPadding:
                                EdgeInsets.zero.copyWith(left: 10.w),
                          ),
                        ),
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
                      Container(
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
                            if (nameController.text.length > 2 &&
                                cityController.text.isNotEmpty) {
                              if (nameController.text !=
                                  LocalStorage.getUserName()) {
                                // if user changed name
                                await LocalStorage.setUserName(
                                    nameController.text);
                                event.patchName(nameController.text, context);
                              }
                              if (cityController.text !=
                                  LocalStorage.getSelectedCity()) {
                                await LocalStorage.setSelectedCity(
                                    cityController.text);
                                await LocalStorage.setSelectedCityLat(
                                    selectedCity?.latitude ?? "");
                                await LocalStorage.setSelectedCityLon(
                                    selectedCity?.longitude ?? "");
                                event.patchCity(selectedCity, context);
                              }
                              context.replaceRoute(const Registration4Route());
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
                    ],
                  ),
                ),
              ),
            ),
            // waves
            Align(
              alignment: Alignment.bottomCenter,
              child: nameFocus.hasFocus
                  ? const SizedBox()
                  : SizedBox(
                      child: SvgPicture.asset(
                        "assets/svg/Vector 13.svg",
                        width: width,
                      ),
                    ),
            ),
          ],
        ),
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
