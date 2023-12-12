import 'package:activity/application/settings/settings_notifier.dart';
import 'package:activity/application/settings/settings_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/custom_textformfield.dart';
import 'package:activity/presentation/components/dummy_data.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PopupBody extends StatefulWidget {
  final SettingsNotifier event;
  final SettingsState state;
  const PopupBody({super.key, required this.event, required this.state});

  @override
  State<PopupBody> createState() => _PopupBodyState();
}

class _PopupBodyState extends State<PopupBody> {
  final listofaddresses = DummyData().cityNames;
  final layerlink = LayerLink();
  GlobalKey sizedBoxKey = GlobalKey();
  OverlayEntry? entry;
  late TextEditingController cityController;
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController heightController;

  @override
  void initState() {
    super.initState();
    cityController =
        TextEditingController(text: LocalStorage.getSelectedCity());
    nameController = TextEditingController(text: LocalStorage.getUserName());
    ageController = TextEditingController(text: LocalStorage.getAge());
    weightController = TextEditingController(text: LocalStorage.getWeight());
    heightController = TextEditingController(text: LocalStorage.getHeight());
  }

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listofaddresses.length,
                        itemBuilder: (context, index) {
                          final currentCity = listofaddresses[index];
                          return _listiles(
                            currentCity.name ?? "",
                            () {
                              //LocalStorage.setSelectedCity(currentCity);
                              //event.setSelectedCity();
                              cityController.text = currentCity.name!;
                              setState(() {});
                              hideOverlay();
                              widget.event.cityTextFieldUnfocus();
                            },
                          );
                        },
                      ),
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
    return SingleChildScrollView(
      child: CustomCard(
        borderColor: Colors.transparent,
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              child: CustomTextFormField(
                contentPadding: EdgeInsets.zero.copyWith(left: 5.w),
                controller: nameController,
              ),
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
                child: CustomTextFormField(
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
                ),
              ),
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
                      child: CustomTextFormField(
                        controller: ageController,
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
                      child: CustomTextFormField(
                        controller: weightController,
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
                      child: CustomTextFormField(
                        controller: heightController,
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
              height: 80.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: AppColors.fadedBlueBorder,
                    child: Padding(
                      padding: EdgeInsets.all(3.r),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: AppConstants.owlNetworkImage,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return const SizedBox();
                          },
                        ),
                      ),
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
                          onPressed: () {},
                          text: "Заменить",
                        ),
                      ),
                      5.verticalSpace,
                      Expanded(
                        child: CustomButton(
                          width: 190.w,
                          fontSize: 14.sp,
                          borderColor: AppColors.fadedBlueBorder,
                          onPressed: () {},
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  width: 130.w,
                  height: 40.h,
                  fontSize: 14.sp,
                  buttonColor: Colors.white,
                  onPressed: () {
                    context.popRoute();
                  },
                  text: "Отменить",
                ),
                CustomButton(
                  width: 130.w,
                  height: 40.h,
                  fontSize: 14.sp,
                  buttonColor: AppColors.blueColor,
                  borderColor: AppColors.blueBorder,
                  textColor: Colors.white,
                  onPressed: () {
                    // check whether user added new data
                    if (LocalStorage.getUserName() !=
                        nameController.text.trim()) {
                      LocalStorage.setUserName(nameController.text)
                          .then((value) => widget.event.setName());
                    }
                    if (LocalStorage.getSelectedCity() != cityController.text) {
                      LocalStorage.setSelectedCity(cityController.text)
                          .then((value) => widget.event.setSelectedCity());
                    }
                    if (LocalStorage.getAge() != ageController.text) {
                      LocalStorage.setAge(ageController.text)
                          .then((value) => widget.event.setAge());
                    }
                    if (LocalStorage.getWeight() != weightController.text) {
                      LocalStorage.setWeight(weightController.text)
                          .then((value) => widget.event.setWeight());
                    }
                    if (LocalStorage.getHeight() != heightController.text) {
                      LocalStorage.setHeight(heightController.text)
                          .then((value) => widget.event.setHeight());
                    }
                    context.popRoute();
                  },
                  text: "Сохранить",
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
