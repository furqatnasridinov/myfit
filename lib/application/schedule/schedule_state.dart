import 'package:activity/infrastructure/models/data/schedule_and_gym.dart';
import 'package:activity/infrastructure/models/response/user_schedules_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../infrastructure/models/data/completed_schedule.dart';

part 'schedule_state.freezed.dart';

@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    @Default(false) bool isloading,
    @Default({}) Map<String, dynamic> schedulesInMapForm,
    @Default([]) List<UserSchedulesResponse> listOfuserSchedules,
    @Default([]) List<CompletedSchedule> waitingSchedules,
    @Default(true) bool showTillWhen,
    @Default(false) bool qrLoading,
    @Default(false) bool plusState,
    @Default([]) List<String> daysFromLastWeek,
    @Default(false) bool isLocationButtonActivated,
    @Default(false) bool isFlashButtonActivated,
    @Default({}) Map<String, dynamic> notesMapData,
    @Default([]) List<ScheduleAndGym> schedulesFoundBySearching,
    @Default("30") String notificationTime,
    @Default(false) bool completedSchedulesShown,
    @Default(false) bool pendingSchedulesShown,
    @Default([]) List<CompletedSchedule> completedSchedules,
  }) = _ScheduleState;
  const ScheduleState._();
}
