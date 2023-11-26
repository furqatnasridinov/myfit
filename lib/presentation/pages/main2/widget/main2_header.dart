import 'dart:ui';
import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/infrastructure/services/typing_delay.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Main2Header extends StatefulWidget implements PreferredSizeWidget {
  final ScheduleState state;
  final ScheduleNotifier event;
  final TextEditingController controller;
  const Main2Header({
    super.key,
    required this.state,
    required this.event,
    required this.controller,
  });

  @override
  State<Main2Header> createState() => _MainHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(55.h);
}

class _MainHeaderState extends State<Main2Header> {
  String previousText = "";

  @override
  Widget build(BuildContext context) {
    if (widget.controller.text.length > 1 &&
        widget.controller.text != previousText) {
      widget.event.searchingSchedules(
        context,
        schedule: widget.controller.text,
      );
      previousText = widget.controller.text;
    }
    print("controller text >>  ${widget.controller.text}");
    print("previous text >> $previousText");
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromRGBO(245, 249, 255, 0.966),
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0.0,
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
        duration: const Duration(milliseconds: 500),
        width: widget.state.isSearchbarOpened ? 344.w : 300.w,
        height: 40.h,
        margin: EdgeInsets.only(left: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: widget.state.isSearchbarOpened
                ? AppColors.blueColor
                : AppColors.greyBorder,
            width: 1.w,
          ),
        ),
        padding: EdgeInsets.only(
          right: 7.w, /* top: 3.h */
        ),
        child: TextField(
          style: GoogleFonts.raleway(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),

          onChanged: (value) {
            widget.controller.text = value;
            setState(() {});
          },
          controller: widget.controller,
          onTap: () {
            if (!widget.state.isSearchbarOpened) {
              widget.event.openSearchBar();
            }
          },
          onEditingComplete: () {
            widget.event.closeSearchBar();
            FocusScope.of(context).unfocus();
          },
          //focusNode: widget.textfieldFocusnode,
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: widget.state.isSearchbarOpened &&
                    widget.controller.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      if (widget.controller.text.isEmpty) {
                        widget.event.closeSearchBar();
                      } else {
                        widget.controller.clear();
                        setState(() {});
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
            hintStyle: GoogleFonts.raleway(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            hintText: "Найти занятие",
            border: InputBorder.none,
          ),
        ),
      ),

      // action
      actions: [
        widget.state.isSearchbarOpened
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
                    top: 4.5.h, right: 16.w, bottom: 4.5.h, left: 5.w),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20.w,
                        top: 8.h,
                        bottom: 8.h,
                      ),
                      child: InkWell(
                        onTap: () {
                          context.router.push(
                            const ScheduleRoute(),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/svg/calendar.svg',
                          width: 24.w,
                          height: 24.h,
                        ),
                        //onTap: () => {context.go('/schedule')},
                      ),
                    ),
                    12.horizontalSpace,
                    SizedOverflowBox(
                      size: Size(40.w, 40.h),
                      child: CircleAvatar(
                        radius: 19.r,
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
