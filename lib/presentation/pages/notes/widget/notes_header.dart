import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NotesHeader extends StatefulWidget implements PreferredSizeWidget {
  const NotesHeader({super.key});

  @override
  State<NotesHeader> createState() => _MainHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(55.h);
}

class _MainHeaderState extends State<NotesHeader> {
  FocusNode textfieldFocusnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (textfieldFocusnode.hasFocus) {
      print("focusnode has focus");
    } else {
      print("focusnode has no focus");
    }

    return AppBar(
      automaticallyImplyLeading: false,
      //backgroundColor: const Color.fromRGBO(245, 249, 255, 0.976),
      backgroundColor: Colors.white.withOpacity(0.96),
      elevation: 0,
      centerTitle: false,

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
        duration: const Duration(milliseconds: 2500),
        width: textfieldFocusnode.hasFocus ? double.maxFinite : 300.w,
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
                height: 40.h,
                decoration: BoxDecoration(
                  //color: Colors.amber,
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
                            child: Image.network(
                              AppConstants.owlNetworkImage,
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
