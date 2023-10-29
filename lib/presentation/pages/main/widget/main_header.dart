import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MainHeader extends StatefulWidget implements PreferredSizeWidget {
  const MainHeader({super.key});

  @override
  State<MainHeader> createState() => _MainHeaderState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(55.h);
}

class _MainHeaderState extends State<MainHeader> {
  FocusNode textfieldFocusnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (textfieldFocusnode.hasFocus) {
      print("focusnode has focus");
    } else {
      print("focusnode has no focus");
    }

    return AppBar(
      //backgroundColor: Colors.transparent,
      //backgroundColor: const Color.fromRGBO(245, 249, 255, 0.966),
      backgroundColor: Colors.white.withOpacity(0.96),
      elevation: 0,
      centerTitle: false,

      // title
      title: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: textfieldFocusnode.hasFocus ? 340.w : 300.w,
        height: 40.h,
        decoration: BoxDecoration(
          //color: Colors.red,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: textfieldFocusnode.hasFocus
                ? AppColors.blueColor
                : AppColors.greyBorder,
            width: 1.w,
          ),
        ),
        child: TextField(
          onTap: () {
            textfieldFocusnode.requestFocus();
            setState(() {});
          },
          onTapOutside: (event) {
            textfieldFocusnode.unfocus();
            setState(() {});
          },
          focusNode: textfieldFocusnode,
          decoration: InputDecoration(
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
