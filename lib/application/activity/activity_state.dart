import 'package:myfit/infrastructure/models/data/description_and_peculiarities.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';
import 'package:myfit/infrastructure/models/response/gym_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../infrastructure/models/data/enrolling_error_message.dart';
part 'activity_state.freezed.dart';

@freezed
class ActivityState with _$ActivityState {
  const factory ActivityState({
    @Default(false) bool isGymLoading,
    @Default(false) bool isActivitiesListLoading,
    @Default(false) bool isEnrollingLoading,
    @Default(false) bool isPhotosLoading,
    @Default(false) bool isSchedulesLoading,
    @Default(false) bool infoForTypeLoading,
    @Default(null) GymResponse? gym,
    @Default(null) DescribtionAndPeculiarities? describtionAndPeculiarities,
    @Default([]) List<String>? activityTypes,
    @Default({}) Map<String, dynamic> allPhotos,
    @Default({}) Map<String, dynamic> allLessons,
    @Default([]) List<Lesson> lessonsOfSelectedActivity,
    @Default([])
    List<String> daysInWhichWeHaveLessons, // [Вс 25 Фев, Пн 26 Фев]
    @Default("") String? selectedCalendarDay,
    @Default([]) List<Lesson> lessonsToShowAfterSelectingADay,
    @Default("") String? selectedActivity,
    @Default([]) List<String> photosOfSelectedActivity,
    @Default({}) Map<String, dynamic> infosForType,
    @Default([]) List<String> listOf15CalendarDaysFromNow,
    @Default(null) EnrollingErrorMessage? enrollingError,
  }) = _ActivityState;

  const ActivityState._();
}
