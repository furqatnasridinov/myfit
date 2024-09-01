
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfit/infrastructure/models/data/gym_with_activities_data.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';

import '../../infrastructure/models/data/membership.dart';
import '../../infrastructure/models/response/user_schedules_response.dart';


part 'membership_state.freezed.dart';

@freezed
class MembershipState with _$MembershipState {
  const factory MembershipState({
    @Default(false) bool isloading,
    @Default("") String selectedActivity,
    @Default(null) Subcategory? selectedSubCategory,
    @Default([]) List<MemberShip> membershipsOfUser,
    @Default([]) List<Subcategory> subCategories,
    @Default([]) List<MemberShip> memberships,
    @Default([]) List<MemberShip> membershipsToShow,
    @Default([]) List<int> gymIds,
    @Default(false) bool getAllMembershipsLoading,
    @Default(false) bool getUserMembershipsLoading,
    @Default(false) bool buyMembershipLoading,
    @Default([])List<GymWithActivitiesData> gymsWithActivitiesdatas,
    @Default(false) bool activityDatasLoading,
    @Default(null) Gym? selectedGym,
  }) = _MembershipState;
  const MembershipState._();
}
