import 'dart:ui';
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
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../infrastructure/models/data/gym_data.dart';

class Main2Header extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final bool showBackButton;
  final bool canNavigateToSettings;
  double? height;
  Main2Header(
      {required this.showBackButton,
      required this.canNavigateToSettings,
      this.height = 55,
      super.key});

  @override
  ConsumerState<Main2Header> createState() => _MainHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(height ?? 55.h);
}

class _MainHeaderState extends ConsumerState<Main2Header> {
  late TextEditingController controller;
  late FocusNode textfieldFocusnode;
  late LayerLink layerlink;
  OverlayEntry? entry;
  String previousText = "";
  bool showAvatar = true;
  bool _showBack = false;

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
                final textFieldRenderBox =
                    context.findRenderObject() as RenderBox;
                final textFieldRect =
                    textFieldRenderBox.localToGlobal(Offset.zero) &
                        textFieldRenderBox.size;
                if (!textFieldRect.contains(position)) {
                  textfieldFocusnode.unfocus();
                  setState(() {});
                }
              },
              child: Consumer(builder: (context, ref, child) {
                final lessonsFoundBySearch =
                    ref.watch(mapProvider).lessonsFoundBySearch;
                final gymsFoundBySearch =
                    ref.watch(mapProvider).gymsFoundBySearch;
                List combinedList = [
                  ...lessonsFoundBySearch,
                  ...gymsFoundBySearch
                ];
                return controller.text.length > 1
                    ? Container(
                        //height: 160.h,
                        constraints:
                            BoxConstraints.loose(Size(double.maxFinite, 300.h)),
                        margin: EdgeInsets.only(left: 16.w, right: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                          border: Border.all(
                            width: 1.0,
                            color: const Color.fromRGBO(119, 170, 249, 1),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 16.w),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              controller.text.length > 1 && combinedList.isEmpty
                                  ? CustomText(
                                      text:
                                          "По вашему запросу ничего не найдено! ",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    )
                                  : MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxHeight: 200.h),
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
                                  if (controller.text.length > 1 &&
                                      combinedList.isNotEmpty) {
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
                      )
                    : const SizedBox.shrink();
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

  Future<void> _updateOverlay() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      entry?.markNeedsBuild();
      //setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    textfieldFocusnode = FocusNode();
    layerlink = LayerLink();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!_showBack) {
        if (widget.showBackButton && !_showBack) {
          _showBack = true;
          setState(() {});
        }
      }
    });

    textfieldFocusnode.addListener(() {
      handleShowAvatar();
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
        _updateOverlay();
      }
      if (ref.watch(mapProvider).gymFoundBySearching.isEmpty &&
          controller.text.isNotEmpty) {
        _updateOverlay();
      }
    });
  }

  Future<void> handleShowAvatar() async {
    if (textfieldFocusnode.hasFocus) {
      showAvatar = false;
      _showBack = false;
      setState(() {});
    } else {
      await Future.delayed(const Duration(milliseconds: 1200));
      showAvatar = true;
      _showBack = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    textfieldFocusnode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      //backgroundColor: Colors.amber,
      toolbarHeight: 40.h,
      //backgroundColor: AppColors.backgroundColor,
      backgroundColor: Colors.red,
      elevation: 0,
      leadingWidth: (widget.showBackButton && !textfieldFocusnode.hasFocus) ? null : 0,
      centerTitle: false,
      titleSpacing: 0, //textfieldFocusnode.hasFocus ? 14.w : 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),

      // leading
      leading: _showBack ?
      GestureDetector(
              onTap: () {
                context.popRoute();
              },
              child: DecoratedBox(
                //margin: EdgeInsets.only(left: 10.5.w),
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
            ) : const SizedBox.shrink(),

      // title
      title: AnimatedContainer(
        margin: EdgeInsets.only(
            left: (widget.showBackButton && !textfieldFocusnode.hasFocus) ? 0 : 13.w,
            right: 16),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        width: textfieldFocusnode.hasFocus ? 390.w : 300.w,
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
        padding: EdgeInsets.only(right: 7.w, top: 1.h),
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
              suffixIcon:
                  textfieldFocusnode.hasFocus && controller.text.isNotEmpty
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

      // action
      actions: [
        if (showAvatar)
          Padding(
            padding: EdgeInsets.only(right: 15.w),
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
