import 'dart:ui';

import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/dummy_data.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MainHeader extends StatefulWidget implements PreferredSizeWidget {
  const MainHeader({super.key});

  @override
  State<MainHeader> createState() => _MainHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(55.h);
}

class _MainHeaderState extends State<MainHeader> {
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
                textfieldFocusnode.unfocus();
                setState(() {});
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
      //backgroundColor: Color.fromRGBO(245, 249, 255, 0.5),
      backgroundColor: const Color.fromRGBO(245, 249, 255, 0.966),
      //backgroundColor: Colors.white.withOpacity(0.96),
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

      // title
      title: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: textfieldFocusnode.hasFocus ? 340.w : 300.w,
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
        child: CompositedTransformTarget(
          link: layerlink,
          child: TextField(
            controller: controller,
            onTap: () {
              if (textfieldFocusnode.hasFocus) {
                return;
              } else {
                textfieldFocusnode.requestFocus();
                setState(() {});
              }
            },
            focusNode: textfieldFocusnode,
            decoration: InputDecoration(
              /* suffixIcon: textfieldFocusnode.hasFocus
                  ? InkWell(
                      onTap: () {
                        controller.clear();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: Icon(
                          Icons.clear,
                          color: Colors.black,
                          size: 18.r,
                        ),
                      ),
                    )
                  : null, */
              prefixIcon: Container(
                margin: EdgeInsets.all(3.r),
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
              hintText: "Найти занятие",
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero.copyWith(
                left: 12.w,
                top: 8.h,
              ),
            ),
          ),
        ),
      ),

      // action
      actions: [
        textfieldFocusnode.hasFocus
            ? const SizedBox()
            : Container(
                width: 40.w,
                height: 40.h,
                margin: EdgeInsets.all(4.r),
                padding: EdgeInsets.all(2.r),
                decoration: const BoxDecoration(
                  color: AppColors.blueColor,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(AppConstants.owlNetworkImage),
                ),
              )
      ],
    );
  }
}
