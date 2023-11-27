import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DecoratedTextOne extends StatelessWidget {
  const DecoratedTextOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/countbgr.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            const SizedBox(height: 40.0),
            SizedBox(
              child: Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    '15 324',
                    style: GoogleFonts.exo2(
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w700,
                      shadows: const [
                        Shadow(
                          color: Color.fromRGBO(255, 136, 136, 1),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        )
                      ],
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.5
                        ..color = const Color.fromRGBO(
                          255,
                          136,
                          136,
                          1,
                        ),
                    ),
                  ),
                  Text(
                    '15 324',
                    style: GoogleFonts.exo2(
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 5),
                          color: Color.fromRGBO(255, 136, 136, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Наших пользователей сходят  на этой неделе ',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'в бассейн',
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.blueColor),
                  ),
                ],
              ),
            )
          ]),
        ),
        Positioned(
          bottom: 36.h,
          left: 72.w,
          child: Image(
            image: const AssetImage('assets/images/1.png'),
            height: 26.h,
          ),
        ),
        Positioned(
          bottom: 57.h,
          right: 33.w,
          child: Image(
            image: const AssetImage('assets/images/2.png'),
            height: 28.h,
          ),
        ),
        Positioned(
          bottom: 187.h,
          right: 20.w,
          child: Image(
            image: const AssetImage('assets/images/3.png'),
            height: 28.h,
          ),
        ),
       /*  Positioned(
          bottom: 190.h,
          left: 30.w,
          child: Image(
            image: const AssetImage('assets/images/4.png'),
            height: 15.h,
          ),
        ), */
        Positioned(
          bottom: 170.h,
          right: 59.w,
          child: Image(
            image: const AssetImage('assets/images/5.png'),
            height: 19.h,
          ),
        ),
        Positioned(
          bottom: 152.h,
          left: 25.w,
          child: Image(
            image: const AssetImage('assets/images/6.png'),
            height: 30.h,
          ),
        ),
        Positioned(
          bottom: 40.h,
          right: 123.w,
          child: Image(
            image: const AssetImage('assets/images/7.png'),
            height: 30.h,
          ),
        ),
        Positioned(
          bottom: 218.h,
          left: 158.w,
          child: Image(
            image: const AssetImage('assets/images/8.png'),
            height: 20.h,
          ),
        ),
        Positioned(
          bottom: 63.h,
          left: 165.w,
          child: Image(
            image: const AssetImage('assets/images/9.png'),
            height: 28.h,
          ),
        ),
        /* Positioned(
          bottom: 171.h,
          left: 67.w,
          child: Image(
            image: const AssetImage('assets/images/1.png'),
            height: 28.h,
          ),
        ),
        Positioned(
          top: 0.h,
          right: 136.w,
          child: Image(
            image: const AssetImage('assets/images/1.png'),
            height: 28.h,
          ),
        ), */
      ],
    );
  }
}
