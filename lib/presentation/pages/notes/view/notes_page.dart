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
  final String gymName; //Фитнес-клуб Mytimefitness
  const NotesScreen({super.key, required this.gymName});

  @override
  ConsumerState<NotesScreen> createState() => _ScheduleItemScreen();
}

class _ScheduleItemScreen extends ConsumerState<NotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(scheduleProvider.notifier).getNotes(context, widget.gymName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleProvider);
    final event = ref.read(scheduleProvider.notifier);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: const NotesHeader(),
      body: state.isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 5.h)),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList.builder(
                      itemCount: state.listOfGymWithTags.length,
                      itemBuilder: (context, index) {
                        final current = state.listOfGymWithTags[index];
                        return NotesCardMaker(
                          state: state,
                          event: event,
                          name: current.gym?.name ?? "??",
                          startTime: current.date ?? "?",
                          description: current.description ?? "?",
                          day: current.date ?? "?",
                          gymWithTags: current,
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
