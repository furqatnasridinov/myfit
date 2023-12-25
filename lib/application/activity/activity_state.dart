import 'package:activity/infrastructure/models/data/activity.dart';
import 'package:activity/infrastructure/models/response/gym_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_state.freezed.dart';

@freezed
class ActivityState with _$ActivityState {
  const factory ActivityState({
    @Default(false) bool isloading,
    @Default(false) bool isGymLoading,
    @Default(false) bool isActivitiesListLoading,
    @Default(false) bool isPhotosLoading,
    @Default(false) bool isSchedulesLoading,
    @Default(null) GymResponse? gym,
    @Default([]) List<String>? activities,
    @Default("") String? selectedActivity,
    @Default([]) List? photos,
    @Default([]) List<String> originalDates,
    @Default({}) Map<String, dynamic> scheddules,
    @Default([]) List<String> availableFormattedDates,
    @Default([]) List<Activity> listOfSchedules,
    @Default("") String defaultDate,
    @Default("") String selectedOriginalDate,
    @Default([]) List<String> listOf15CalendarDaysFromNow,
    @Default([]) List<String> listOf15OriginalDaysFromNow,
    @Default("") String selectedFormattedDay,
  }) = _ActivityState;

  const ActivityState._();
}
