import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SelectPeriodOne extends StatefulWidget {
  const SelectPeriodOne({super.key});

  @override
  State<SelectPeriodOne> createState() => _SelectPeriodOneState();
}

class _SelectPeriodOneState extends State<SelectPeriodOne> {
  String chosenSchedulesTime = 'сегодня';
  bool geoButton = false;
  bool flashButton = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            CustomText(
              text: 'Заметки за ',
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
            UiDropDownMenu(
                dropDownItemsList: [
                  {
                    'title': 'За неделю',
                    'icon': SvgPicture.asset(
                      'assets/svg/seven.svg',
                      colorFilter: const ColorFilter.mode(
                        Color.fromRGBO(62, 134, 245, 1),
                        BlendMode.srcIn,
                      ),
                    ),
                    'action': () {
                      setState(() {
                        chosenSchedulesTime = 'неделю';
                      });
                    }
                  },
                  {
                    'title': 'За месяц',
                    'icon': SvgPicture.asset(
                      'assets/svg/thirty.svg',
                      colorFilter: const ColorFilter.mode(
                        Color.fromRGBO(62, 134, 245, 1),
                        BlendMode.srcIn,
                      ),
                    ),
                    'action': () {
                      setState(() {
                        chosenSchedulesTime = 'месяц';
                      });
                    }
                  },
                  {
                    'title': 'За всё время',
                    'icon': SvgPicture.asset('assets/svg/infinity.svg',
                        colorFilter: const ColorFilter.mode(
                            Color.fromRGBO(62, 134, 245, 1), BlendMode.srcIn)),
                    'action': () {
                      setState(() {
                        chosenSchedulesTime = 'всё время';
                      });
                    }
                  }
                ],
                dropDownChild: CustomText(
                  text: chosenSchedulesTime,
                  fontWeight: FontWeight.w800,
                  fontSize: 20.sp,
                  color: AppColors.blueColor,
                  //style: MyFitAppFonts.h1(MyFitAppColors.txtBlue),
                ),
                leftCornerShape: true
                //
                ),
          ],
        ),
        const Spacer(),
        _scheduleItemAction(),
      ],
    );
  }

  _scheduleItemAction() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  width: 1.0,
                  color: geoButton == false
                      ? const Color.fromRGBO(233, 233, 233, 1)
                      : const Color.fromRGBO(62, 134, 245, 1)),
            ),
            child: IconButton(
              iconSize: 30.0,
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                shadowColor: Colors.transparent,
              ),
              padding: const EdgeInsets.only(left: 4, right: 4, top: 0),
              icon: Padding(
                padding: const EdgeInsets.all(0.0),
                child: geoButton == false
                    ? SvgPicture.asset('assets/svg/geoTag.svg')
                    : SvgPicture.asset('assets/svg/geoTag.svg',
                        colorFilter: const ColorFilter.mode(
                            Color.fromRGBO(62, 134, 245, 1), BlendMode.srcIn)),
              ),
              onPressed: () {
                setState(() {
                  geoButton = !geoButton;
                });
              },
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                width: 1.0,
                color: flashButton == false
                    ? const Color.fromRGBO(233, 233, 233, 1)
                    : const Color.fromRGBO(62, 134, 245, 1),
              ),
            ),
            child: IconButton(
              iconSize: 30.0,
              padding: const EdgeInsets.only(left: 4, right: 4, top: 0),
              icon: Padding(
                padding: const EdgeInsets.all(0.0),
                child: flashButton == false
                    ? SvgPicture.asset('assets/svg/activity.svg')
                    : SvgPicture.asset(
                        'assets/svg/activity.svg',
                        colorFilter: const ColorFilter.mode(
                          Color.fromRGBO(62, 134, 245, 1),
                          BlendMode.srcIn,
                        ),
                      ),
              ),
              onPressed: () {
                setState(() {
                  flashButton = !flashButton;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
