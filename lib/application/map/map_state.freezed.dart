// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MapState {
  bool get isloading => throw _privateConstructorUsedError;
  Position? get userPosition => throw _privateConstructorUsedError;
  List<EachMarkersModel> get listOfMarkers =>
      throw _privateConstructorUsedError;
  List<GymData> get listOfActivities => throw _privateConstructorUsedError;
  EachMarkersModel? get activeMarker => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapStateCopyWith<MapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapStateCopyWith<$Res> {
  factory $MapStateCopyWith(MapState value, $Res Function(MapState) then) =
      _$MapStateCopyWithImpl<$Res, MapState>;
  @useResult
  $Res call(
      {bool isloading,
      Position? userPosition,
      List<EachMarkersModel> listOfMarkers,
      List<GymData> listOfActivities,
      EachMarkersModel? activeMarker});
}

/// @nodoc
class _$MapStateCopyWithImpl<$Res, $Val extends MapState>
    implements $MapStateCopyWith<$Res> {
  _$MapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isloading = null,
    Object? userPosition = freezed,
    Object? listOfMarkers = null,
    Object? listOfActivities = null,
    Object? activeMarker = freezed,
  }) {
    return _then(_value.copyWith(
      isloading: null == isloading
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool,
      userPosition: freezed == userPosition
          ? _value.userPosition
          : userPosition // ignore: cast_nullable_to_non_nullable
              as Position?,
      listOfMarkers: null == listOfMarkers
          ? _value.listOfMarkers
          : listOfMarkers // ignore: cast_nullable_to_non_nullable
              as List<EachMarkersModel>,
      listOfActivities: null == listOfActivities
          ? _value.listOfActivities
          : listOfActivities // ignore: cast_nullable_to_non_nullable
              as List<GymData>,
      activeMarker: freezed == activeMarker
          ? _value.activeMarker
          : activeMarker // ignore: cast_nullable_to_non_nullable
              as EachMarkersModel?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MapStateImplCopyWith<$Res>
    implements $MapStateCopyWith<$Res> {
  factory _$$MapStateImplCopyWith(
          _$MapStateImpl value, $Res Function(_$MapStateImpl) then) =
      __$$MapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isloading,
      Position? userPosition,
      List<EachMarkersModel> listOfMarkers,
      List<GymData> listOfActivities,
      EachMarkersModel? activeMarker});
}

/// @nodoc
class __$$MapStateImplCopyWithImpl<$Res>
    extends _$MapStateCopyWithImpl<$Res, _$MapStateImpl>
    implements _$$MapStateImplCopyWith<$Res> {
  __$$MapStateImplCopyWithImpl(
      _$MapStateImpl _value, $Res Function(_$MapStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isloading = null,
    Object? userPosition = freezed,
    Object? listOfMarkers = null,
    Object? listOfActivities = null,
    Object? activeMarker = freezed,
  }) {
    return _then(_$MapStateImpl(
      isloading: null == isloading
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool,
      userPosition: freezed == userPosition
          ? _value.userPosition
          : userPosition // ignore: cast_nullable_to_non_nullable
              as Position?,
      listOfMarkers: null == listOfMarkers
          ? _value._listOfMarkers
          : listOfMarkers // ignore: cast_nullable_to_non_nullable
              as List<EachMarkersModel>,
      listOfActivities: null == listOfActivities
          ? _value._listOfActivities
          : listOfActivities // ignore: cast_nullable_to_non_nullable
              as List<GymData>,
      activeMarker: freezed == activeMarker
          ? _value.activeMarker
          : activeMarker // ignore: cast_nullable_to_non_nullable
              as EachMarkersModel?,
    ));
  }
}

/// @nodoc

class _$MapStateImpl extends _MapState {
  const _$MapStateImpl(
      {this.isloading = false,
      this.userPosition = null,
      final List<EachMarkersModel> listOfMarkers = const [],
      final List<GymData> listOfActivities = const [],
      this.activeMarker = null})
      : _listOfMarkers = listOfMarkers,
        _listOfActivities = listOfActivities,
        super._();

  @override
  @JsonKey()
  final bool isloading;
  @override
  @JsonKey()
  final Position? userPosition;
  final List<EachMarkersModel> _listOfMarkers;
  @override
  @JsonKey()
  List<EachMarkersModel> get listOfMarkers {
    if (_listOfMarkers is EqualUnmodifiableListView) return _listOfMarkers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listOfMarkers);
  }

  final List<GymData> _listOfActivities;
  @override
  @JsonKey()
  List<GymData> get listOfActivities {
    if (_listOfActivities is EqualUnmodifiableListView)
      return _listOfActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listOfActivities);
  }

  @override
  @JsonKey()
  final EachMarkersModel? activeMarker;

  @override
  String toString() {
    return 'MapState(isloading: $isloading, userPosition: $userPosition, listOfMarkers: $listOfMarkers, listOfActivities: $listOfActivities, activeMarker: $activeMarker)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapStateImpl &&
            (identical(other.isloading, isloading) ||
                other.isloading == isloading) &&
            (identical(other.userPosition, userPosition) ||
                other.userPosition == userPosition) &&
            const DeepCollectionEquality()
                .equals(other._listOfMarkers, _listOfMarkers) &&
            const DeepCollectionEquality()
                .equals(other._listOfActivities, _listOfActivities) &&
            (identical(other.activeMarker, activeMarker) ||
                other.activeMarker == activeMarker));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isloading,
      userPosition,
      const DeepCollectionEquality().hash(_listOfMarkers),
      const DeepCollectionEquality().hash(_listOfActivities),
      activeMarker);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      __$$MapStateImplCopyWithImpl<_$MapStateImpl>(this, _$identity);
}

abstract class _MapState extends MapState {
  const factory _MapState(
      {final bool isloading,
      final Position? userPosition,
      final List<EachMarkersModel> listOfMarkers,
      final List<GymData> listOfActivities,
      final EachMarkersModel? activeMarker}) = _$MapStateImpl;
  const _MapState._() : super._();

  @override
  bool get isloading;
  @override
  Position? get userPosition;
  @override
  List<EachMarkersModel> get listOfMarkers;
  @override
  List<GymData> get listOfActivities;
  @override
  EachMarkersModel? get activeMarker;
  @override
  @JsonKey(ignore: true)
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
