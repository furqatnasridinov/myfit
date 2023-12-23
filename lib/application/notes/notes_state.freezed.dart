// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotesState {
  bool get isloading => throw _privateConstructorUsedError;
  List<GymWithTags> get listOfGymWithTags => throw _privateConstructorUsedError;
  List<GymWithTags> get listOfGymWithTagsWithNewAddedTags =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotesStateCopyWith<NotesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotesStateCopyWith<$Res> {
  factory $NotesStateCopyWith(
          NotesState value, $Res Function(NotesState) then) =
      _$NotesStateCopyWithImpl<$Res, NotesState>;
  @useResult
  $Res call(
      {bool isloading,
      List<GymWithTags> listOfGymWithTags,
      List<GymWithTags> listOfGymWithTagsWithNewAddedTags});
}

/// @nodoc
class _$NotesStateCopyWithImpl<$Res, $Val extends NotesState>
    implements $NotesStateCopyWith<$Res> {
  _$NotesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isloading = null,
    Object? listOfGymWithTags = null,
    Object? listOfGymWithTagsWithNewAddedTags = null,
  }) {
    return _then(_value.copyWith(
      isloading: null == isloading
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool,
      listOfGymWithTags: null == listOfGymWithTags
          ? _value.listOfGymWithTags
          : listOfGymWithTags // ignore: cast_nullable_to_non_nullable
              as List<GymWithTags>,
      listOfGymWithTagsWithNewAddedTags: null ==
              listOfGymWithTagsWithNewAddedTags
          ? _value.listOfGymWithTagsWithNewAddedTags
          : listOfGymWithTagsWithNewAddedTags // ignore: cast_nullable_to_non_nullable
              as List<GymWithTags>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotesStateImplCopyWith<$Res>
    implements $NotesStateCopyWith<$Res> {
  factory _$$NotesStateImplCopyWith(
          _$NotesStateImpl value, $Res Function(_$NotesStateImpl) then) =
      __$$NotesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isloading,
      List<GymWithTags> listOfGymWithTags,
      List<GymWithTags> listOfGymWithTagsWithNewAddedTags});
}

/// @nodoc
class __$$NotesStateImplCopyWithImpl<$Res>
    extends _$NotesStateCopyWithImpl<$Res, _$NotesStateImpl>
    implements _$$NotesStateImplCopyWith<$Res> {
  __$$NotesStateImplCopyWithImpl(
      _$NotesStateImpl _value, $Res Function(_$NotesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isloading = null,
    Object? listOfGymWithTags = null,
    Object? listOfGymWithTagsWithNewAddedTags = null,
  }) {
    return _then(_$NotesStateImpl(
      isloading: null == isloading
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool,
      listOfGymWithTags: null == listOfGymWithTags
          ? _value._listOfGymWithTags
          : listOfGymWithTags // ignore: cast_nullable_to_non_nullable
              as List<GymWithTags>,
      listOfGymWithTagsWithNewAddedTags: null ==
              listOfGymWithTagsWithNewAddedTags
          ? _value._listOfGymWithTagsWithNewAddedTags
          : listOfGymWithTagsWithNewAddedTags // ignore: cast_nullable_to_non_nullable
              as List<GymWithTags>,
    ));
  }
}

/// @nodoc

class _$NotesStateImpl extends _NotesState {
  const _$NotesStateImpl(
      {this.isloading = false,
      final List<GymWithTags> listOfGymWithTags = const [],
      final List<GymWithTags> listOfGymWithTagsWithNewAddedTags = const []})
      : _listOfGymWithTags = listOfGymWithTags,
        _listOfGymWithTagsWithNewAddedTags = listOfGymWithTagsWithNewAddedTags,
        super._();

  @override
  @JsonKey()
  final bool isloading;
  final List<GymWithTags> _listOfGymWithTags;
  @override
  @JsonKey()
  List<GymWithTags> get listOfGymWithTags {
    if (_listOfGymWithTags is EqualUnmodifiableListView)
      return _listOfGymWithTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listOfGymWithTags);
  }

  final List<GymWithTags> _listOfGymWithTagsWithNewAddedTags;
  @override
  @JsonKey()
  List<GymWithTags> get listOfGymWithTagsWithNewAddedTags {
    if (_listOfGymWithTagsWithNewAddedTags is EqualUnmodifiableListView)
      return _listOfGymWithTagsWithNewAddedTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listOfGymWithTagsWithNewAddedTags);
  }

  @override
  String toString() {
    return 'NotesState(isloading: $isloading, listOfGymWithTags: $listOfGymWithTags, listOfGymWithTagsWithNewAddedTags: $listOfGymWithTagsWithNewAddedTags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotesStateImpl &&
            (identical(other.isloading, isloading) ||
                other.isloading == isloading) &&
            const DeepCollectionEquality()
                .equals(other._listOfGymWithTags, _listOfGymWithTags) &&
            const DeepCollectionEquality().equals(
                other._listOfGymWithTagsWithNewAddedTags,
                _listOfGymWithTagsWithNewAddedTags));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isloading,
      const DeepCollectionEquality().hash(_listOfGymWithTags),
      const DeepCollectionEquality().hash(_listOfGymWithTagsWithNewAddedTags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotesStateImplCopyWith<_$NotesStateImpl> get copyWith =>
      __$$NotesStateImplCopyWithImpl<_$NotesStateImpl>(this, _$identity);
}

abstract class _NotesState extends NotesState {
  const factory _NotesState(
          {final bool isloading,
          final List<GymWithTags> listOfGymWithTags,
          final List<GymWithTags> listOfGymWithTagsWithNewAddedTags}) =
      _$NotesStateImpl;
  const _NotesState._() : super._();

  @override
  bool get isloading;
  @override
  List<GymWithTags> get listOfGymWithTags;
  @override
  List<GymWithTags> get listOfGymWithTagsWithNewAddedTags;
  @override
  @JsonKey(ignore: true)
  _$$NotesStateImplCopyWith<_$NotesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
