import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widget/widget.dart';

@RoutePage()
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const NotificationAppbar(),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Column(
              children: [
                // tab section
                Container(
                  height: 40.h,
                  margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.fadedBlueBorder,
                      width: 1.w,
                    ),
                  ),
                  padding: EdgeInsets.all(4.r),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.zero,
                    labelStyle: GoogleFonts.raleway(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    indicator: BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.circular(6.r),
                      boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            offset: Offset(0, 2), 
                            blurRadius: 5, 
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(109, 150, 212, 1),
                            offset: Offset(0, 15), 
                            blurRadius: 18, 
                            spreadRadius: -15, 
                          ),
                        ],
                    ),
                    tabs: const [
                      Tab(text: "Все"),
                      Tab(text: "Активности"),
                      Tab(text: "Предложения"),
                    ],
                  ),
                ),
              ],
            ),

            // tab bar view
            const  Expanded(
              child: TabBarView(
                children: [
                   TabSectionAll(),
                   TabSectionAll(),
                   //TabSectionActivities(),
                   TabSectionNews(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
