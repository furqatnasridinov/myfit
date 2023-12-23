import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/edit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MySubscribtion extends StatelessWidget {
  const MySubscribtion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Моя подписка",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            EditButton(
              onTap: () {},
            ),
          ],
        ),
        10.verticalSpace,
        Container(
          width: double.maxFinite,
          height: 113.h,
          //padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFEBC072), width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                offset: Offset(0.0, 2.0),
                blurRadius: 5.0,
              ),
              BoxShadow(
                color: Color(0xFF9E4EC5),
                offset: Offset(0.0, 19.0),
                blurRadius: 27.0,
                spreadRadius: -18.0,
              ),
            ],
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFEBC072),
                Color(0xFF9A49C9),
              ],
              stops: [-0.4115, 1.3761],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      height: 80.h,
                      child: Image.asset(
                        'assets/images/corona.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    32.horizontalSpace,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Премиум",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '\$20 ',
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        const Color.fromRGBO(236, 215, 219, 1)),
                              ),
                              TextSpan(
                                text: "в месяц",
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromRGBO(236, 215, 219, 1)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.maxFinite,
                  child: Image.asset(
                    "assets/images/subs_line.png",
                    fit: BoxFit.cover,
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
