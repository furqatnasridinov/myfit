import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/pages/notes/widget/notes_header.dart';
import 'package:activity/presentation/pages/notes/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

@RoutePage()
class NotesScreen extends ConsumerStatefulWidget {
  final String day;
  const NotesScreen({super.key, required this.day});

  @override
  ConsumerState<NotesScreen> createState() => _ScheduleItemScreen();
}

class _ScheduleItemScreen extends ConsumerState<NotesScreen> {
  bool geoButton = false;
  bool flashButton = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleProvider);
    final event = ref.read(scheduleProvider.notifier);
    List<String> parts = widget.day.split("@");
    String dayToFormat = parts[0];
    final formattedDay = event.formatDay(dayToFormat);
    print(formattedDay);
    final List<dynamic> scheduleItemsData =
        state.schedulesInMapForm[dayToFormat];
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: const NotesHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Заметки за",
                          style: GoogleFonts.raleway(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(
                            width: 5.w,
                          ),
                        ),
                        TextSpan(
                          text: formattedDay,
                          style: GoogleFonts.raleway(
                            color: AppColors.blueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _scheduleItemAction(),
                ],
              ),
              32.verticalSpace,
              SizedBox(
                width: 350.w,
                height: 500.h,
                child: ListView.builder(
                  itemCount: scheduleItemsData.length,
                  itemBuilder: (context, index) {
                    return NotesCardMaker(
                      address: scheduleItemsData[index]["gym"]["address"],
                      startTime: scheduleItemsData[index]["date"],
                      description: scheduleItemsData[index]["description"],
                    );
                  },
                ),
              )
              //const NotesCardMaker(),
              /* CustomText(
                text: widget.day,
              ) */
              /* const SelectPeriodOne(),
              32.verticalSpace,
              const ScheduleItemCard(),
              25.verticalSpace,
              const ScheduleItemCard(),
              25.verticalSpace,
              const ScheduleItemCard(),
              25.verticalSpace,
              const ScheduleItemCard(), */
            ],
          ),
        ),
      ),
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
                    : const Color.fromRGBO(62, 134, 245, 1),
              ),
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
