import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/pages/notes/widget/notes_header.dart';
import 'package:activity/presentation/pages/notes/widget/widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class NotesScreen extends ConsumerStatefulWidget {
  final String day; //2023-11-11@15:15
  const NotesScreen({super.key, required this.day});

  @override
  ConsumerState<NotesScreen> createState() => _ScheduleItemScreen();
}

class _ScheduleItemScreen extends ConsumerState<NotesScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(scheduleProvider.notifier).addNote(
          "Проверка",
          "Номер 1 ",
          6,
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleProvider);
    final event = ref.read(scheduleProvider.notifier);
    List<String> parts = widget.day.split("@"); //2023-11-11@15:15
    String dayToFormat = parts[0]; //2023-11-11
    final formattedDay = event.formatDay(dayToFormat); // Ноябрь 11
    print(formattedDay);
    final List<dynamic> scheduleItemsData =
        state.schedulesInMapForm[dayToFormat];
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: const NotesHeader(),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w)
                  .copyWith(top: 7.h, bottom: 32.h),
              sliver: SliverToBoxAdapter(
                child: NotesTopSection(
                  event: event,
                  state: state,
                  formattedDay: formattedDay,
                ),
              ),
            ),

            // body

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList.builder(
                itemCount: scheduleItemsData.length,
                itemBuilder: (context, index) {
                  return NotesCardMaker(
                    name: scheduleItemsData[index]["gym"]["name"],
                    startTime: scheduleItemsData[index]["date"],
                    description: scheduleItemsData[index]["description"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
