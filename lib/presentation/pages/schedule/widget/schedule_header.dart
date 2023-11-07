import 'dart:ui';

import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/dummy_data.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleHeader extends StatefulWidget implements PreferredSizeWidget {
  const ScheduleHeader({super.key});

  @override
  State<ScheduleHeader> createState() => _MainHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(55.h);
}

class _MainHeaderState extends State<ScheduleHeader> {
  TextEditingController controller = TextEditingController();
  FocusNode textfieldFocusnode = FocusNode();
  final layerlink = LayerLink();
  final listofaddresses = DummyData().dummyAddresses;

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
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listofaddresses.length,
                        itemBuilder: (context, index) {
                          final currentGym = listofaddresses[index];
                          return ListTile(
                            onTap: () {
                              controller.text = currentGym.name;
                              textfieldFocusnode.unfocus();
                              setState(() {});
                            },
                            title: CustomText(
                              text: currentGym.name,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            subtitle: CustomText(
                              text: currentGym.destination,
                              color: AppColors.greyText,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  UiButtonFilled(
                    btnText: 'Показать на карте',
                    onPressedAction: () => print('123'),
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

  @override
  void initState() {
    super.initState();

    textfieldFocusnode.addListener(() {
      if (textfieldFocusnode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (textfieldFocusnode.hasFocus) {
      print("focusnode has focus");
    } else {
      print("focusnode has no focus");
    }

    return AppBar(
      automaticallyImplyLeading: false,
      //backgroundColor: Colors.amber,
      backgroundColor: const Color.fromRGBO(245, 249, 255, 0.966),
      elevation: 0,
      centerTitle: false,
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
              margin: EdgeInsets.all(5.r),
              width: 40.w,
              height: 40.h,
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(233, 233, 233, 1),
                    width: 1.w,
                  ),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () => context.popRoute(),
                  borderRadius: BorderRadius.circular(500.r),
                  child: SizedBox(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      size: 24.r,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

      // title
      title: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: textfieldFocusnode.hasFocus ? double.maxFinite : 350.w,
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
        padding: EdgeInsets.only(right: 7.w, top: 3.h),
        child: CompositedTransformTarget(
          link: layerlink,
          child: TextField(
            controller: controller,
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
              suffixIcon: textfieldFocusnode.hasFocus
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
                          size: 18.r,
                        ),
                      ),
                    )
                  : null,
              prefixIcon: Container(
                margin: EdgeInsets.all(2.r),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(10.r),
                child: SvgPicture.asset(
                  "assets/svg/search.svg",
                  // ignore: deprecated_member_use
                  color: AppColors.blueColor,
                ),
              ),
              hintText: "Занятие, зал",
              border: InputBorder.none,
              /* contentPadding: EdgeInsets.zero.copyWith(
                left: 12.w,
                top: 8.h,
              ), */
            ),
          ),
        ),
      ),

      // action
      actions: [
        textfieldFocusnode.hasFocus
            ? const SizedBox()
            : Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: AppColors.greyBorder,
                    width: 1.w,
                  ),
                ),
                margin: EdgeInsets.only(
                  top: 4.5.h,
                  right: 16.w,
                  bottom: 4.5.h,
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
                          width: 24.w,
                          height: 24.h,
                        ),
                        //onTap: () => {context.go('/schedule')},
                      ),
                    ),
                    SizedBox(width: 12.w),
                    SizedOverflowBox(
                      size: Size(40.w, 40.h),
                      child: CircleAvatar(
                        radius: 100.r,
                        backgroundColor: const Color.fromRGBO(119, 170, 249, 1),
                        child: Padding(
                          padding: EdgeInsets.all(2.r),
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
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
