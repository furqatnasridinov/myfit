import 'package:activity/infrastructure/models/data/gym_with_tags.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'notes_state.freezed.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    @Default(false) bool isloading,
    @Default([]) List<GymWithTags> listOfGymWithTags,
    @Default([]) List<GymWithTags> listOfGymWithTagsWithNewAddedTags,
  }) = _NotesState;
  const NotesState._();
}
