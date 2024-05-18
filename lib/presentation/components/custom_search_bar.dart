import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/models/data/lessons_found_by_search.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

import '../../infrastructure/models/data/gym_data.dart';

class CustomSearchBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool canNavigateToSettings;
  double? height;
  CustomSearchBar(
      {super.key,
      required this.showBackButton,
      required this.canNavigateToSettings,
      this.height});

  @override
  ConsumerState<CustomSearchBar> createState() => _CustomSearchBarState();

  

  @override
  Size get preferredSize => Size.fromHeight(height ?? 55.h);
}

class _CustomSearchBarState extends ConsumerState<CustomSearchBar> {
  late TextEditingController controller;
  late FocusNode textfieldFocusnode;
  late LayerLink layerlink;
  OverlayEntry? entry;
  String previousText = "";


  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    textfieldFocusnode = FocusNode();
    layerlink = LayerLink();

    textfieldFocusnode.addListener(() {
      if (textfieldFocusnode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });

    controller.addListener(() {
      if (controller.text.length > 1 && controller.text != previousText) {
        ref.read(mapProvider.notifier).searchForGymAndLesson(
              context,
              searchString: controller.text,
            );
        previousText = controller.text;
        updateOverlay();
      }
      if (ref.watch(mapProvider).gymFoundBySearching.isEmpty &&
          controller.text.isNotEmpty) {
        updateOverlay();
      }
    });
  }

   @override
  void dispose() {
    super.dispose();
    controller.dispose();
    textfieldFocusnode.dispose();
  }

    void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    //final offset = renderBox.localToGlobal(Offset.zero);
    entry = OverlayEntry(
      builder: (context) => Positioned(
        /* left: offset.dx,
        top: offset.dy + size.height + 2.5, */
        width: size.width,
        child: CompositedTransformFollower(
          offset: Offset(-16, 50.h),
          link: layerlink,
          child: Material(
            color: Colors.transparent,
            child: TapRegion(
              onTapOutside: (event) {
                final position = event.position;
                final textFieldRenderBox =context.findRenderObject() as RenderBox;
                final textFieldRect =textFieldRenderBox.localToGlobal(Offset.zero) & textFieldRenderBox.size;
                if (!textFieldRect.contains(position)) {
                  textfieldFocusnode.unfocus();
                  setState(() {});
                }
              },
              child: Consumer(builder: (context, ref, child) {
                final lessonsFoundBySearch = ref.watch(mapProvider).lessonsFoundBySearch;
                final gymsFoundBySearch = ref.watch(mapProvider).gymsFoundBySearch;
                List combinedList = [
                  ...lessonsFoundBySearch,
                  ...gymsFoundBySearch
                ];
                return 
                     Container(
                        //duration: const Duration(milliseconds: 300),
                        //curve: Curves.easeInOut,
                        height: controller.text.length <= 1 ? 0 : null ,//getContainerHeight(combinedList.length),
                        //constraints:BoxConstraints.loose(Size(double.maxFinite, 300.h)),
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
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller.text.length > 1 && combinedList.isEmpty
                                    ? CustomText(
                                        text: "По вашему запросу ничего не найдено! ",
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      )
                                    : MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        child: ConstrainedBox(
                                          constraints:BoxConstraints(maxHeight: 200.h),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: combinedList.length,
                                            itemBuilder: (context, index) {
                                              final current = combinedList[index];
                                              if (current is GymData) {
                                                return _listiles(
                                                  "Заведение - ${current.name}",
                                                  "${current.distanceFromClient} км",
                                                  () {
                                                    textfieldFocusnode.unfocus();
                                                    setState(() {});
                                                    context.router.push(ActivityRoute(gymId:current.id ?? 0));
                                                    controller.clear();
                                                  },
                                                );
                                              }
                                              if (current
                                                  is LessonFoundBySearch) {
                                                return _listiles(
                                                  "Занятие - ${current.title}",
                                                  current.distanceFromClient !=null ? "${current.distanceFromClient} км" : "",
                                                  () {
                                                    textfieldFocusnode.unfocus();
                                                    setState(() {});
                                                    ref.read(activityProvider.notifier)
                                                    ..setDayOfSelectedLessonFromSearch(current.date ?? "")
                                                    ..setIsFromSearch(true);
                                                    ref.read(mapProvider.notifier).setSelectedActivityFromMap(
                                                            AppHelpers().getTranslatedLessonType(engLessonType:current.lessonType ??""));
                                                    context.router.push(ActivityRoute(gymId:current.gymId ?? 0));
                                                    controller.clear();
                                                  },
                                                );
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 10.0),
                                CustomButton(
                                  onPressed: () {
                                    if (controller.text.length > 1 && combinedList.isNotEmpty) {
                                      context.router.push(const MapRoute());
                                      textfieldFocusnode.unfocus();
                                      controller.clear();
                                      setState(() {});
                                    } else {
                                      textfieldFocusnode.unfocus();
                                      controller.clear();
                                      setState(() {});
                                    }
                                  },
                                  text: controller.text.length > 1 &&
                                          combinedList.isNotEmpty
                                      ? "Перейти к карте"
                                      : "Закрыть",
                                  buttonColor: AppColors.blueColor,
                                  borderColor: AppColors.blueBorder,
                                  textColor: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 40.h,
                                ),
                              ]),
                        ),
                      );
              }),
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

  Future<void> updateOverlay() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      entry?.markNeedsBuild();
      //setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.red,
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
    
                //back button
                if (widget.showBackButton)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  left: textfieldFocusnode.hasFocus ? -100 : 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      context.popRoute();
                    },
                    child: SizedBox(
                      height: 40.h,
                      width: 40.w,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.greyBorder,
                            width: 1.w,
                          ),
                          color: Colors.white,
                          shape: BoxShape.circle,
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
                  ),
                ),
            
                // textfield            
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  left: widget.showBackButton && !textfieldFocusnode.hasFocus ? 45.w : 0,
                  curve: Curves.easeInOut,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    //curve: Curves.easeInOut,
                    width: textfieldFocusnode.hasFocus ? constraints.maxWidth : widget.showBackButton ? 250.w : 295.w,
                    //width: 250.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(
                        color: textfieldFocusnode.hasFocus
                            ? AppColors.blueColor
                            : AppColors.greyBorder,
                        width: 1.w,
                      ),
                    ),
                    //padding: EdgeInsets.only(right: 7.w, top: 1.h),
                    child: CompositedTransformTarget(
                      link: layerlink,
                      child: TextField(
                        controller: controller,
                        style: GoogleFonts.raleway(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          fontFeatures: const [FontFeature.liningFigures()],
                        ),
                        onChanged: (value) {
                          controller.text = value;
                          setState(() {});
                        },
                        onTap: () {
                          textfieldFocusnode.requestFocus();
                          setState(() {});
                        },
                        onEditingComplete: () {
                          textfieldFocusnode.unfocus();
                          setState(() {});
                        },
                        focusNode: textfieldFocusnode,
                        decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: textfieldFocusnode.hasFocus &&
                                  controller.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    if (controller.text.isEmpty) {
                                      textfieldFocusnode.unfocus();
                                      setState(() {});
                                    } else {
                                      controller.clear();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 0.w),
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                      size: 15.5.r,
                                    ),
                                  ),
                                )
                              : null,
                          prefixIcon: Container(
                            margin: EdgeInsets.all(4.r).copyWith(left: 0.w),
                            decoration: const BoxDecoration(
                              color: AppColors.backgroundColor,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(5.r),
                            child: SvgPicture.asset(
                              "assets/svg/search.svg",
                              // ignore: deprecated_member_use
                              color: AppColors.blueColor,
                            ),
                          ),
                          hintStyle: GoogleFonts.raleway(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFeatures: const [FontFeature.liningFigures()],
                          ),
                          hintText: "Занятие, зал",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
            
                // avatar            
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  right: textfieldFocusnode.hasFocus ? -100 : 0,
                  bottom: 0,
                  child: Consumer(builder: (context, ref, child) {
                    final settingsState = ref.watch(settingsProvider);
                    return GestureDetector(
                      onTap: () {
                        if (widget.canNavigateToSettings) {
                          context.router.push(const SettingsRoute());
                        }
                      },
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: AppColors.blueColor,
                        child: settingsState.avatar.isEmpty
                            ? CircleAvatar(
                                radius: 18.r,
                                backgroundImage:
                                    const AssetImage(AppConstants.cristianBale))
                            : CircleAvatar(
                                radius: 18.r,
                                backgroundImage: NetworkImage(
                                    "http://77.222.53.122/image/${settingsState.avatar}"),
                                onBackgroundImageError: (exception, stackTrace) {
                                  debugPrint(exception.toString());
                                },
                              ),
                      ),
                    );
                  }),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

Widget _listiles(
  String name,
  String km,
  void Function()? onTap,
) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(left: 10.w, bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: name,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          InterText(
            text: km,
            color: AppColors.greyText,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    ),
  );
}


double getContainerHeight(int length){
  log("length: $length");
  if(length == 1){
    return 135.h;
  }
  if(length == 2){
    return 190.h;
  }
  if(length == 3){
    return 245.h;
  }
  if(length >= 4 ){
    return 280.h;
  }
  if (length == 0) {
    return 105.h;
  }
  return 0;

}