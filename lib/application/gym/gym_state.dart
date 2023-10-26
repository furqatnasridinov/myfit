import 'package:activity/infrastructure/models/response/gym_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gym_state.freezed.dart';

@freezed
class GymState with _$GymState {
  const factory GymState({
    @Default(false) bool isloading,
    @Default(null) GymResponse? gym,
    @Default([]) List<String>? activities,
    @Default("") String? selectedActivity,
    @Default([]) List? photos,
    @Default([]) List<String> originalDates,
    @Default({}) Map<String, dynamic> scheddules,
    @Default([]) List availableDates,
    @Default([]) List listOfSchedules,
    @Default("") String defaultDate,
    @Default("") String selectedOriginalDate,
    @Default([]) List<String> listOfDates,
    @Default("") String selectedDay,
  }) = _GymState;

  const GymState._();
}
