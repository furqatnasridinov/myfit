import 'dart:ui';
import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MapHeader extends StatefulWidget implements PreferredSizeWidget {
  final MapNotifier event;
  final MapState state;
  const MapHeader({super.key, required this.event, required this.state});

  @override
  State<MapHeader> createState() => _MainHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(55.h);
}

class _MainHeaderState extends State<MapHeader> {
  late TextEditingController controller;
  late FocusNode textfieldFocusnode;
  late LayerLink layerlink;
  String previousText = "";
  OverlayEntry? entry;

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    // final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
      builder: (context) => Positioned(
        // left: offset.dx,
        // top: offset.dy + size.height + 2.5,
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
              child: Container(
                height: controller.text.isEmpty ||
                        widget.state.gymFoundBySearching.isEmpty
                    ? 160.h
                    : 290.h,
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.text.isEmpty
                          ? Center(
                              child: CustomText(
                                text:
                                    "Напишите в поиск названия заведения которого хотите найти!",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : controller.text.length > 1 &&
                                  widget.state.gymFoundBySearching.isEmpty
                              ? CustomText(
                                  text: "По вашему запросу ничего не найдено! ",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                )
                              : Expanded(
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.builder(
                                      //shrinkWrap: true,
                                      itemCount: widget
                                          .state.gymFoundBySearching.length,
                                      itemBuilder: (context, index) {
                                        final currentGym = widget
                                            .state.gymFoundBySearching[index];
                                        return _listiles(
                                          currentGym.name ?? "??",
                                          "${currentGym.distanceFromClient.toString()} км от вас",
                                          () {
                                            textfieldFocusnode.unfocus();
                                            setState(() {});
                                            context.router.push(
                                              ActivityRoute(
                                                  gymId: currentGym.id!),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                      const SizedBox(height: 10.0),
                      UiButtonFilled(
                        btnText: 'Закрыть',
                        onPressedAction: () {
                          textfieldFocusnode.unfocus();
                          setState(() {});
                        },
                        isFullWidth: true,
                      )
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
    textfieldFocusnode.addListener(() {
      if (textfieldFocusnode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    textfieldFocusnode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.text.length > 1 && controller.text != previousText) {
      widget.event.searchGym(
        context,
        text: controller.text,
      );
      previousText = controller.text;
      _updateOverlay();
    }
    if (widget.state.gymFoundBySearching.isEmpty &&
        controller.text.isNotEmpty) {
      _updateOverlay();
    }

    return AppBar(
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 40.h,
      backgroundColor: const Color.fromRGBO(245, 249, 255, 0.966),
      elevation: 0,
      centerTitle: false,
      titleSpacing: textfieldFocusnode.hasFocus ? 14.w : 5.0,
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
      leading: textfieldFocusnode.hasFocus
          ? null
          : Container(
              margin: EdgeInsets.only(left: 10.5.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(233, 233, 233, 1),
                  width: 1.w,
                ),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () async {
                  widget.event.removePopUp();
                  if (widget.state.showMapOnly) {
                    widget.event.reduceMap();
                  }
                  context.popRoute();
                },
                child: SizedBox(
                  child: SvgPicture.asset(
                    "assets/svg/back_icon.svg",
                    fit: BoxFit.none,
                  ),
                ),
              ),
            ),

      // title
      title: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: textfieldFocusnode.hasFocus ? 380.w : 300.w,
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
        padding: EdgeInsets.only(
          right: 7.w,
          //top: 3.h,
        ),
        child: CompositedTransformTarget(
          link: layerlink,
          child: TextField(
            style: GoogleFonts.raleway(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFeatures: const [FontFeature.liningFigures()],
            ),
            controller: controller,
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
              hintText: "Найти занятие",
              border: InputBorder.none,
            ),
          ),
        ),
      ),

      // action
      actions: [
        textfieldFocusnode.hasFocus
            ? const SizedBox()
            : Container(
                width: 95.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.greyBorder,
                      width: 1.w,
                    ),
                    top: BorderSide(
                      color: AppColors.greyBorder,
                      width: 1.w,
                    ),
                    left: BorderSide(
                      color: AppColors.greyBorder,
                      width: 1.w,
                    ),
                  ),
                ),
                margin: EdgeInsets.only(
                  right: 16.w,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20.w,
                        top: 8.h,
                        bottom: 8.h,
                      ),
                      child: GestureDetector(
                        child: SvgPicture.asset(
                          'assets/svg/calendar.svg',
                        ),
                        //onTap: () => {context.go('/schedule')},
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: const Color.fromRGBO(119, 170, 249, 1),
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
                  ],
                ),
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
