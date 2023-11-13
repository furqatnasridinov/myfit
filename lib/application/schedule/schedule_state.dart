
import 'package:activity/infrastructure/models/response/get_nearest_lesson_response.dart';
import 'package:activity/infrastructure/models/response/get_user_stats_month_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_state.freezed.dart';

@freezed
class ScheduleState with _$ScheduleState{
  const factory ScheduleState({
    @Default(false) bool isloading,
    @Default(false) bool isSearchbarOpened,
    @Default({})Map<String,dynamic> schedulesInMapForm,
    @Default([])List listOfUserSchedulesvalues,
    @Default(false)bool showTillWhen,
    @Default(false)bool plusState,
    @Default(false) bool isLocationButtonActivated,
    @Default(false) bool isFlashButtonActivated,
    @Default(null) GetNearestLesson? nearestLesson,
    @Default("") String whenActivityStarts,
    @Default(null)GetUserStatsMonthResponse? statsForMonth,
  }) = _ScheduleState;
  const ScheduleState._();
}
