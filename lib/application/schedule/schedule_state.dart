
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
  }) = _ScheduleState;
  const ScheduleState._();
}
