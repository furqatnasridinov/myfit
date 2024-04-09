// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ScheduleState {
  bool get isloading => throw _privateConstructorUsedError;
  Map<String, dynamic> get schedulesInMapForm =>
      throw _privateConstructorUsedError;
  List<UserSchedulesResponse> get listOfuserSchedules =>
      throw _privateConstructorUsedError;
  List<CompletedSchedule> get waitingSchedules =>
      throw _privateConstructorUsedError;
  bool get showTillWhen => throw _privateConstructorUsedError;
  bool get plusState => throw _privateConstructorUsedError;
  List<String> get daysFromLastWeek => throw _privateConstructorUsedError;
  bool get isLocationButtonActivated => throw _privateConstructorUsedError;
  bool get isFlashButtonActivated => throw _privateConstructorUsedError;
  Map<String, dynamic> get notesMapData => throw _privateConstructorUsedError;
  List<ScheduleAndGym> get schedulesFoundBySearching =>
      throw _privateConstructorUsedError;
  String get notificationTime => throw _privateConstructorUsedError;
  bool get completedSchedulesShown => throw _privateConstructorUsedError;
  bool get pendingSchedulesShown => throw _privateConstructorUsedError;
  List<CompletedSchedule> get completedSchedules =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScheduleStateCopyWith<ScheduleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleStateCopyWith<$Res> {
  factory $ScheduleStateCopyWith(
          ScheduleState value, $Res Function(ScheduleState) then) =
      _$ScheduleStateCopyWithImpl<$Res, ScheduleState>;
  @useResult
  $Res call(
      {bool isloading,
      Map<String, dynamic> schedulesInMapForm,
      List<UserSchedulesResponse> listOfuserSchedules,
      List<CompletedSchedule> waitingSchedules,
      bool showTillWhen,
      bool plusState,
      List<String> daysFromLastWeek,
      bool isLocationButtonActivated,
      bool isFlashButtonActivated,
      Map<String, dynamic> notesMapData,
      List<ScheduleAndGym> schedulesFoundBySearching,
      String notificationTime,
      bool completedSchedulesShown,
      bool pendingSchedulesShown,
      List<CompletedSchedule> completedSchedules});
}

/// @nodoc
class _$ScheduleStateCopyWithImpl<$Res, $Val extends ScheduleState>
    implements $ScheduleStateCopyWith<$Res> {
  _$ScheduleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isloading = null,
    Object? schedulesInMapForm = null,
    Object? listOfuserSchedules = null,
    Object? waitingSchedules = null,
    Object? showTillWhen = null,
    Object? plusState = null,
    Object? daysFromLastWeek = null,
    Object? isLocationButtonActivated = null,
    Object? isFlashButtonActivated = null,
    Object? notesMapData = null,
    Object? schedulesFoundBySearching = null,
    Object? notificationTime = null,
    Object? completedSchedulesShown = null,
    Object? pendingSchedulesShown = null,
    Object? completedSchedules = null,
  }) {
    return _then(_value.copyWith(
      isloading: null == isloading
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool,
      schedulesInMapForm: null == schedulesInMapForm
          ? _value.schedulesInMapForm
          : schedulesInMapForm // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      listOfuserSchedules: null == listOfuserSchedules
          ? _value.listOfuserSchedules
          : listOfuserSchedules // ignore: cast_nullable_to_non_nullable
              as List<UserSchedulesResponse>,
      waitingSchedules: null == waitingSchedules
          ? _value.waitingSchedules
          : waitingSchedules // ignore: cast_nullable_to_non_nullable
              as List<CompletedSchedule>,
      showTillWhen: null == showTillWhen
          ? _value.showTillWhen
          : showTillWhen // ignore: cast_nullable_to_non_nullable
              as bool,
      plusState: null == plusState
          ? _value.plusState
          : plusState // ignore: cast_nullable_to_non_nullable
              as bool,
      daysFromLastWeek: null == daysFromLastWeek
          ? _value.daysFromLastWeek
          : daysFromLastWeek // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLocationButtonActivated: null == isLocationButtonActivated
          ? _value.isLocationButtonActivated
          : isLocationButtonActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      isFlashButtonActivated: null == isFlashButtonActivated
          ? _value.isFlashButtonActivated
          : isFlashButtonActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      notesMapData: null == notesMapData
          ? _value.notesMapData
          : notesMapData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      schedulesFoundBySearching: null == schedulesFoundBySearching
          ? _value.schedulesFoundBySearching
          : schedulesFoundBySearching // ignore: cast_nullable_to_non_nullable
              as List<ScheduleAndGym>,
      notificationTime: null == notificationTime
          ? _value.notificationTime
          : notificationTime // ignore: cast_nullable_to_non_nullable
              as String,
      completedSchedulesShown: null == completedSchedulesShown
          ? _value.completedSchedulesShown
          : completedSchedulesShown // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingSchedulesShown: null == pendingSchedulesShown
          ? _value.pendingSchedulesShown
          : pendingSchedulesShown // ignore: cast_nullable_to_non_nullable
              as bool,
      completedSchedules: null == completedSchedules
          ? _value.completedSchedules
          : completedSchedules // ignore: cast_nullable_to_non_nullable
              as List<CompletedSchedule>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleStateImplCopyWith<$Res>
    implements $ScheduleStateCopyWith<$Res> {
  factory _$$ScheduleStateImplCopyWith(
          _$ScheduleStateImpl value, $Res Function(_$ScheduleStateImpl) then) =
      __$$ScheduleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isloading,
      Map<String, dynamic> schedulesInMapForm,
      List<UserSchedulesResponse> listOfuserSchedules,
      List<CompletedSchedule> waitingSchedules,
      bool showTillWhen,
      bool plusState,
      List<String> daysFromLastWeek,
      bool isLocationButtonActivated,
      bool isFlashButtonActivated,
      Map<String, dynamic> notesMapData,
      List<ScheduleAndGym> schedulesFoundBySearching,
      String notificationTime,
      bool completedSchedulesShown,
      bool pendingSchedulesShown,
      List<CompletedSchedule> completedSchedules});
}

/// @nodoc
class __$$ScheduleStateImplCopyWithImpl<$Res>
    extends _$ScheduleStateCopyWithImpl<$Res, _$ScheduleStateImpl>
    implements _$$ScheduleStateImplCopyWith<$Res> {
  __$$ScheduleStateImplCopyWithImpl(
      _$ScheduleStateImpl _value, $Res Function(_$ScheduleStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isloading = null,
    Object? schedulesInMapForm = null,
    Object? listOfuserSchedules = null,
    Object? waitingSchedules = null,
    Object? showTillWhen = null,
    Object? plusState = null,
    Object? daysFromLastWeek = null,
    Object? isLocationButtonActivated = null,
    Object? isFlashButtonActivated = null,
    Object? notesMapData = null,
    Object? schedulesFoundBySearching = null,
    Object? notificationTime = null,
    Object? completedSchedulesShown = null,
    Object? pendingSchedulesShown = null,
    Object? completedSchedules = null,
  }) {
    return _then(_$ScheduleStateImpl(
      isloading: null == isloading
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool,
      schedulesInMapForm: null == schedulesInMapForm
          ? _value._schedulesInMapForm
          : schedulesInMapForm // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      listOfuserSchedules: null == listOfuserSchedules
          ? _value._listOfuserSchedules
          : listOfuserSchedules // ignore: cast_nullable_to_non_nullable
              as List<UserSchedulesResponse>,
      waitingSchedules: null == waitingSchedules
          ? _value._waitingSchedules
          : waitingSchedules // ignore: cast_nullable_to_non_nullable
              as List<CompletedSchedule>,
      showTillWhen: null == showTillWhen
          ? _value.showTillWhen
          : showTillWhen // ignore: cast_nullable_to_non_nullable
              as bool,
      plusState: null == plusState
          ? _value.plusState
          : plusState // ignore: cast_nullable_to_non_nullable
              as bool,
      daysFromLastWeek: null == daysFromLastWeek
          ? _value._daysFromLastWeek
          : daysFromLastWeek // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLocationButtonActivated: null == isLocationButtonActivated
          ? _value.isLocationButtonActivated
          : isLocationButtonActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      isFlashButtonActivated: null == isFlashButtonActivated
          ? _value.isFlashButtonActivated
          : isFlashButtonActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      notesMapData: null == notesMapData
          ? _value._notesMapData
          : notesMapData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      schedulesFoundBySearching: null == schedulesFoundBySearching
          ? _value._schedulesFoundBySearching
          : schedulesFoundBySearching // ignore: cast_nullable_to_non_nullable
              as List<ScheduleAndGym>,
      notificationTime: null == notificationTime
          ? _value.notificationTime
          : notificationTime // ignore: cast_nullable_to_non_nullable
              as String,
      completedSchedulesShown: null == completedSchedulesShown
          ? _value.completedSchedulesShown
          : completedSchedulesShown // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingSchedulesShown: null == pendingSchedulesShown
          ? _value.pendingSchedulesShown
          : pendingSchedulesShown // ignore: cast_nullable_to_non_nullable
              as bool,
      completedSchedules: null == completedSchedules
          ? _value._completedSchedules
          : completedSchedules // ignore: cast_nullable_to_non_nullable
              as List<CompletedSchedule>,
    ));
  }
}

/// @nodoc

class _$ScheduleStateImpl extends _ScheduleState {
  const _$ScheduleStateImpl(
      {this.isloading = false,
      final Map<String, dynamic> schedulesInMapForm = const {},
      final List<UserSchedulesResponse> listOfuserSchedules = const [],
      final List<CompletedSchedule> waitingSchedules = const [],
      this.showTillWhen = true,
      this.plusState = false,
      final List<String> daysFromLastWeek = const [],
      this.isLocationButtonActivated = false,
      this.isFlashButtonActivated = false,
      final Map<String, dynamic> notesMapData = const {},
      final List<ScheduleAndGym> schedulesFoundBySearching = const [],
      this.notificationTime = "30",
      this.completedSchedulesShown = false,
      this.pendingSchedulesShown = false,
      final List<CompletedSchedule> completedSchedules = const []})
      : _schedulesInMapForm = schedulesInMapForm,
        _listOfuserSchedules = listOfuserSchedules,
        _waitingSchedules = waitingSchedules,
        _daysFromLastWeek = daysFromLastWeek,
        _notesMapData = notesMapData,
        _schedulesFoundBySearching = schedulesFoundBySearching,
        _completedSchedules = completedSchedules,
        super._();

  @override
  @JsonKey()
  final bool isloading;
  final Map<String, dynamic> _schedulesInMapForm;
  @override
  @JsonKey()
  Map<String, dynamic> get schedulesInMapForm {
    if (_schedulesInMapForm is EqualUnmodifiableMapView)
      return _schedulesInMapForm;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_schedulesInMapForm);
  }

  final List<UserSchedulesResponse> _listOfuserSchedules;
  @override
  @JsonKey()
  List<UserSchedulesResponse> get listOfuserSchedules {
    if (_listOfuserSchedules is EqualUnmodifiableListView)
      return _listOfuserSchedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listOfuserSchedules);
  }

  final List<CompletedSchedule> _waitingSchedules;
  @override
  @JsonKey()
  List<CompletedSchedule> get waitingSchedules {
    if (_waitingSchedules is EqualUnmodifiableListView)
      return _waitingSchedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_waitingSchedules);
  }

  @override
  @JsonKey()
  final bool showTillWhen;
  @override
  @JsonKey()
  final bool plusState;
  final List<String> _daysFromLastWeek;
  @override
  @JsonKey()
  List<String> get daysFromLastWeek {
    if (_daysFromLastWeek is EqualUnmodifiableListView)
      return _daysFromLastWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daysFromLastWeek);
  }

  @override
  @JsonKey()
  final bool isLocationButtonActivated;
  @override
  @JsonKey()
  final bool isFlashButtonActivated;
  final Map<String, dynamic> _notesMapData;
  @override
  @JsonKey()
  Map<String, dynamic> get notesMapData {
    if (_notesMapData is EqualUnmodifiableMapView) return _notesMapData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_notesMapData);
  }

  final List<ScheduleAndGym> _schedulesFoundBySearching;
  @override
  @JsonKey()
  List<ScheduleAndGym> get schedulesFoundBySearching {
    if (_schedulesFoundBySearching is EqualUnmodifiableListView)
      return _schedulesFoundBySearching;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedulesFoundBySearching);
  }

  @override
  @JsonKey()
  final String notificationTime;
  @override
  @JsonKey()
  final bool completedSchedulesShown;
  @override
  @JsonKey()
  final bool pendingSchedulesShown;
  final List<CompletedSchedule> _completedSchedules;
  @override
  @JsonKey()
  List<CompletedSchedule> get completedSchedules {
    if (_completedSchedules is EqualUnmodifiableListView)
      return _completedSchedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedSchedules);
  }

  @override
  String toString() {
    return 'ScheduleState(isloading: $isloading, schedulesInMapForm: $schedulesInMapForm, listOfuserSchedules: $listOfuserSchedules, waitingSchedules: $waitingSchedules, showTillWhen: $showTillWhen, plusState: $plusState, daysFromLastWeek: $daysFromLastWeek, isLocationButtonActivated: $isLocationButtonActivated, isFlashButtonActivated: $isFlashButtonActivated, notesMapData: $notesMapData, schedulesFoundBySearching: $schedulesFoundBySearching, notificationTime: $notificationTime, completedSchedulesShown: $completedSchedulesShown, pendingSchedulesShown: $pendingSchedulesShown, completedSchedules: $completedSchedules)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleStateImpl &&
            (identical(other.isloading, isloading) ||
                other.isloading == isloading) &&
            const DeepCollectionEquality()
                .equals(other._schedulesInMapForm, _schedulesInMapForm) &&
            const DeepCollectionEquality()
                .equals(other._listOfuserSchedules, _listOfuserSchedules) &&
            const DeepCollectionEquality()
                .equals(other._waitingSchedules, _waitingSchedules) &&
            (identical(other.showTillWhen, showTillWhen) ||
                other.showTillWhen == showTillWhen) &&
            (identical(other.plusState, plusState) ||
                other.plusState == plusState) &&
            const DeepCollectionEquality()
                .equals(other._daysFromLastWeek, _daysFromLastWeek) &&
            (identical(other.isLocationButtonActivated,
                    isLocationButtonActivated) ||
                other.isLocationButtonActivated == isLocationButtonActivated) &&
            (identical(other.isFlashButtonActivated, isFlashButtonActivated) ||
                other.isFlashButtonActivated == isFlashButtonActivated) &&
            const DeepCollectionEquality()
                .equals(other._notesMapData, _notesMapData) &&
            const DeepCollectionEquality().equals(
                other._schedulesFoundBySearching, _schedulesFoundBySearching) &&
            (identical(other.notificationTime, notificationTime) ||
                other.notificationTime == notificationTime) &&
            (identical(
                    other.completedSchedulesShown, completedSchedulesShown) ||
                other.completedSchedulesShown == completedSchedulesShown) &&
            (identical(other.pendingSchedulesShown, pendingSchedulesShown) ||
                other.pendingSchedulesShown == pendingSchedulesShown) &&
            const DeepCollectionEquality()
                .equals(other._completedSchedules, _completedSchedules));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isloading,
      const DeepCollectionEquality().hash(_schedulesInMapForm),
      const DeepCollectionEquality().hash(_listOfuserSchedules),
      const DeepCollectionEquality().hash(_waitingSchedules),
      showTillWhen,
      plusState,
      const DeepCollectionEquality().hash(_daysFromLastWeek),
      isLocationButtonActivated,
      isFlashButtonActivated,
      const DeepCollectionEquality().hash(_notesMapData),
      const DeepCollectionEquality().hash(_schedulesFoundBySearching),
      notificationTime,
      completedSchedulesShown,
      pendingSchedulesShown,
      const DeepCollectionEquality().hash(_completedSchedules));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleStateImplCopyWith<_$ScheduleStateImpl> get copyWith =>
      __$$ScheduleStateImplCopyWithImpl<_$ScheduleStateImpl>(this, _$identity);
}

abstract class _ScheduleState extends ScheduleState {
  const factory _ScheduleState(
      {final bool isloading,
      final Map<String, dynamic> schedulesInMapForm,
      final List<UserSchedulesResponse> listOfuserSchedules,
      final List<CompletedSchedule> waitingSchedules,
      final bool showTillWhen,
      final bool plusState,
      final List<String> daysFromLastWeek,
      final bool isLocationButtonActivated,
      final bool isFlashButtonActivated,
      final Map<String, dynamic> notesMapData,
      final List<ScheduleAndGym> schedulesFoundBySearching,
      final String notificationTime,
      final bool completedSchedulesShown,
      final bool pendingSchedulesShown,
      final List<CompletedSchedule> completedSchedules}) = _$ScheduleStateImpl;
  const _ScheduleState._() : super._();

  @override
  bool get isloading;
  @override
  Map<String, dynamic> get schedulesInMapForm;
  @override
  List<UserSchedulesResponse> get listOfuserSchedules;
  @override
  List<CompletedSchedule> get waitingSchedules;
  @override
  bool get showTillWhen;
  @override
  bool get plusState;
  @override
  List<String> get daysFromLastWeek;
  @override
  bool get isLocationButtonActivated;
  @override
  bool get isFlashButtonActivated;
  @override
  Map<String, dynamic> get notesMapData;
  @override
  List<ScheduleAndGym> get schedulesFoundBySearching;
  @override
  String get notificationTime;
  @override
  bool get completedSchedulesShown;
  @override
  bool get pendingSchedulesShown;
  @override
  List<CompletedSchedule> get completedSchedules;
  @override
  @JsonKey(ignore: true)
  _$$ScheduleStateImplCopyWith<_$ScheduleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
