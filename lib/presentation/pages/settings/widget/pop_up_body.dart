// ignore_for_file: use_build_context_synchronously

import 'package:activity/application/map/map_provider.dart';
import 'package:activity/application/settings/settings_notifier.dart';
import 'package:activity/application/settings/settings_provider.dart';
import 'package:activity/application/settings/settings_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/custom_textfield.dart';
import 'package:activity/presentation/components/custom_textformfield.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../infrastructure/models/response/auth_response.dart';

class PopupBody extends StatefulWidget {
  final SettingsNotifier event;
  final SettingsState state;
  const PopupBody({super.key, required this.event, required this.state});

  @override
  State<PopupBody> createState() => _PopupBodyState();
}

class _PopupBodyState extends State<PopupBody> {
  final layerlink = LayerLink();
  GlobalKey sizedBoxKey = GlobalKey();
  OverlayEntry? entry;
  City? selectedCity;
  bool isNameEmpty = false;
  late TextEditingController cityController;
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController heightController;

  @override
  void initState() {
    super.initState();
    cityController =
        TextEditingController(text: LocalStorage.getSelectedCity());
    nameController = TextEditingController(text: LocalStorage.getUserName());
    lastNameController = TextEditingController(
        text: LocalStorage.getUserLastName().isEmpty
            ? ""
            : LocalStorage.getUserLastName());
    ageController = TextEditingController(
        text: LocalStorage.getAge().isEmpty ? "" : LocalStorage.getAge());
    weightController = TextEditingController(
        text: LocalStorage.getWeight().isEmpty ? "" : LocalStorage.getWeight());
    heightController = TextEditingController(
        text: LocalStorage.getHeight().isEmpty ? "" : LocalStorage.getHeight());
    widget.event.getListOfCities(context);
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
  }

  void setSelectedCity(City? city) {
    selectedCity = city;
  }

  void showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    // final offset = renderBox.localToGlobal(Offset.zero);
    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          offset: Offset(-20, 50.h),
          link: layerlink,
          child: Material(
            color: Colors.transparent,
            child: TapRegion(
              onTapOutside: (pointerDownEvent) {
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final tapPosition =
                    overlay.globalToLocal(pointerDownEvent.position);
                if (!isTapInsideTextField(tapPosition)) {
                  widget.event.cityTextFieldUnfocus();
                  hideOverlay();
                }
              },
              child: Container(
                height: 240.h,
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
                                setSelectedCity(currentCity);
                                setState(() {});
                                hideOverlay();
                                widget.event.cityTextFieldUnfocus();
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

  bool isTapInsideTextField(Offset globalPosition) {
    final RenderBox textFieldRenderBox =
        sizedBoxKey.currentContext!.findRenderObject() as RenderBox;
    final textFieldPosition = textFieldRenderBox.localToGlobal(Offset.zero);
    final textFieldSize = textFieldRenderBox.size;

    return globalPosition.dx >= textFieldPosition.dx &&
        globalPosition.dx <= textFieldPosition.dx + textFieldSize.width &&
        globalPosition.dy >= textFieldPosition.dy &&
        globalPosition.dy <= textFieldPosition.dy + textFieldSize.height;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.state.cityTextFieldHasFocus) {
        showOverlay(context);
      }
    });
    debugPrint("path ${context.router.current.path}");
    return SingleChildScrollView(
      child: CustomCard(
        borderColor: Colors.transparent,
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Имя
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Ваше имя",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      5.verticalSpace,
                      SizedBox(
                        height: 40.h,
                        child: CustomTextField(
                          isError: isNameEmpty,
                          hasFocus: true,
                          cursorColor: AppColors.greyText,
                          contentPadding: EdgeInsets.zero.copyWith(left: 5.w),
                          controller: nameController,
                          onChanged: (val) {
                            if (val.trim().isEmpty && !isNameEmpty) {
                              isNameEmpty = true;
                              setState(() {});
                            } else if (val.trim().isNotEmpty && isNameEmpty) {
                              isNameEmpty = false;
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                10.horizontalSpace,

                // Фамилия
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
                      SizedBox(
                        height: 40.h,
                        child: CustomTextField(
                          contentPadding: EdgeInsets.zero.copyWith(left: 5.w),
                          controller: lastNameController,
                          hintText: LocalStorage.getUserLastName().isEmpty
                              ? "Фамилия"
                              : "",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            16.verticalSpace,
            CustomText(
              text: "В каком городе искать активности",
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            5.verticalSpace,

            // city textfield
            SizedBox(
              key: sizedBoxKey,
              height: 40.h,
              child: CompositedTransformTarget(
                  link: layerlink,
                  child: widget.state.isCitiesLoading
                      ? CustomTextFormField(
                          contentPadding: EdgeInsets.zero.copyWith(left: 5.w),
                          suffixIcon: SvgPicture.asset(
                            !widget.state.cityTextFieldHasFocus
                                ? "assets/svg/arrow_down.svg"
                                : "assets/svg/arrow_up.svg",
                            fit: BoxFit.none,
                          ),
                          readOnly: true,
                          initialValue: "Загружаем город",
                        )
                      : CustomTextFormField(
                          contentPadding: EdgeInsets.zero.copyWith(left: 5.w),
                          hasFocus: widget.state.cityTextFieldHasFocus,
                          onTap: () {
                            if (!widget.state.cityTextFieldHasFocus) {
                              widget.event.cityTextFieldRequestFocus();
                            }
                          },
                          suffixIcon: SvgPicture.asset(
                            !widget.state.cityTextFieldHasFocus
                                ? "assets/svg/arrow_down.svg"
                                : "assets/svg/arrow_up.svg",
                            fit: BoxFit.none,
                          ),
                          readOnly: true,
                          controller: cityController,
                        )),
            ),
            16.verticalSpace,

            // user data section (возраст, вес, рост)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // возраст
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Возраст",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    5.verticalSpace,
                    SizedBox(
                      width: 93.w,
                      height: 40.h,
                      child: CustomTextField(
                        keyboardType: TextInputType.number,
                        controller: ageController,
                        counterStyle: const TextStyle(
                          height: double.minPositive,
                        ),
                        counterText: "",
                        maxLines: 1,
                        maxLength: 3,
                        contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
                      ),
                    ),
                  ],
                ),

                // вес
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Вес, кг",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    5.verticalSpace,
                    SizedBox(
                      width: 93.w,
                      height: 40.h,
                      child: CustomTextField(
                        keyboardType: TextInputType.number,
                        controller: weightController,
                        counterStyle: const TextStyle(
                          height: double.minPositive,
                        ),
                        counterText: "",
                        maxLines: 1,
                        maxLength: 3,
                        contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
                      ),
                    ),
                  ],
                ),

                // рост
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Рост, см",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    5.verticalSpace,
                    SizedBox(
                      width: 93.w,
                      height: 40.h,
                      child: CustomTextField(
                        keyboardType: TextInputType.number,
                        controller: heightController,
                        counterStyle: const TextStyle(
                          height: double.minPositive,
                        ),
                        counterText: "",
                        maxLines: 1,
                        maxLength: 3,
                        contentPadding: EdgeInsets.zero.copyWith(left: 8.w),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // avatar section
            16.verticalSpace,
            CustomText(
              text: "Аватар",
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            5.verticalSpace,
            SizedBox(
              height: widget.state.avatar.isEmpty ? null : 80.h,
              child: widget.state.avatar.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await widget.event.pickImageFromGallery(context);
                          },
                          child: CircleAvatar(
                            radius: 40.r,
                            backgroundColor: AppColors.backgroundColor,
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: AppColors.blueBorder,
                              ),
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        CustomButton(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 40.r,
                          backgroundColor: AppColors.backgroundColor,
                          child: CircleAvatar(
                            radius: 38.r,
                            backgroundImage: NetworkImage(
                                "http://77.222.53.122/image/${widget.state.avatar}"),
                            onBackgroundImageError: (exception, stackTrace) {
                              debugPrint(exception.toString());
                            },
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomButton(
                                width: 190.w,
                                fontSize: 14.sp,
                                borderColor: AppColors.fadedBlueBorder,
                                onPressed: () async {
                                  await widget.event
                                      .pickImageFromGallery(context);
                                },
                                text: "Заменить",
                              ),
                            ),
                            5.verticalSpace,
                            Expanded(
                              child: CustomButton(
                                width: 190.w,
                                fontSize: 14.sp,
                                borderColor: AppColors.fadedBlueBorder,
                                onPressed: () async {
                                  if (widget.state.avatar.isEmpty) {
                                    return;
                                  } else {
                                    showConfirmationDialog(
                                      context,
                                      () async {
                                        await widget.event
                                            .patchAvatar("", context);
                                        widget.event.getUser(context);
                                        context.router.pop();
                                      },
                                    );
                                  }
                                },
                                text: "Удалить",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            // buttons
            16.verticalSpace,
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    width: 130.w,
                    height: 40.h,
                    fontSize: 14.sp,
                    buttonColor: Colors.white,
                    onPressed: () {
                      context.popRoute();
                    },
                    text: "Отменить",
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final mapEvent = ref.watch(mapProvider.notifier);
                      return CustomButton(
                        showProgress: widget.state.isloading,
                        width: 130.w,
                        height: 40.h,
                        fontSize: 14.sp,
                        buttonColor: AppColors.blueColor,
                        borderColor: AppColors.blueBorder,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (!isNameEmpty) {
                            // check whether user added new data
                            if (LocalStorage.getUserName() !=
                                nameController.text.trim()) {
                              await widget.event.patchName(
                                  nameController.text.trim(), context);
                            }

                            if (LocalStorage.getUserLastName() !=
                                lastNameController.text.trim()) {
                              await widget.event.patchLastname(
                                  lastNameController.text.trim(), context);
                            }

                            if (LocalStorage.getSelectedCity() !=
                                cityController.text) {
                              await widget.event
                                  .patchCity(selectedCity, context);
                              await mapEvent.setLocationFromSelectedCity();
                              await mapEvent.getYandexMapImage(context);
                            }
                            if (LocalStorage.getAge() != ageController.text) {
                              await widget.event
                                  .patchAge(ageController.text, context);
                            }
                            if (LocalStorage.getWeight() !=
                                weightController.text) {
                              await widget.event
                                  .patchWeight(weightController.text, context);
                            }
                            if (LocalStorage.getHeight() !=
                                heightController.text) {
                              await widget.event
                                  .patchHeight(heightController.text, context);
                            }
                            context.popRoute();
                          }
                        },
                        text: "Сохранить",
                      );
                    },
                  ),
                ),
              ],
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
