import 'package:activity/infrastructure/models/data/schedule_and_gym.dart';
import 'package:activity/infrastructure/models/response/get_nearest_lesson_response.dart';
import 'package:activity/infrastructure/models/response/get_user_stats_month_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main2_state.freezed.dart';

@freezed
class Main2State with _$Main2State {
  const factory Main2State({
    @Default(false) bool isloading,
    @Default(false) bool isSearchbarOpened,
    @Default(false) bool showTillWhen,
    @Default(null) GetNearestLesson? nearestLesson,
    @Default("") String whenActivityStarts,
    @Default([]) List<UserStats> statsForMonth,
    @Default([]) List<ScheduleAndGym> schedulesFoundBySearching,
  }) = _Main2State;
  const Main2State._();
}
