
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';

import '../../infrastructure/models/data/membership.dart';


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
  }) = _MembershipState;
  const MembershipState._();
}
