import 'package:activity/infrastructure/models/data/schedule_and_gym.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_state.freezed.dart';

@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    @Default(false) bool isloading,
    @Default({}) Map<String, dynamic> schedulesInMapForm,
    @Default(false) bool showTillWhen,
    @Default(false) bool plusState,
    @Default(false) bool isLocationButtonActivated,
    @Default(false) bool isFlashButtonActivated,
    @Default({}) Map<String, dynamic> notesMapData,
    @Default([]) List<ScheduleAndGym> schedulesFoundBySearching,
    @Default("30 мин") String notificationTime,
  }) = _ScheduleState;
  const ScheduleState._();
}
