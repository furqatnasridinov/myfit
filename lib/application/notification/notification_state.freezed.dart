// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotificationState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<NotificationModel> get allNotifications =>
      throw _privateConstructorUsedError;
  List<NotificationModel> get onlyNewNotifications =>
      throw _privateConstructorUsedError;
  bool get showNewOnly => throw _privateConstructorUsedError;
  bool get hasUnreadNotification => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationStateCopyWith<NotificationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationStateCopyWith<$Res> {
  factory $NotificationStateCopyWith(
          NotificationState value, $Res Function(NotificationState) then) =
      _$NotificationStateCopyWithImpl<$Res, NotificationState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<NotificationModel> allNotifications,
      List<NotificationModel> onlyNewNotifications,
      bool showNewOnly,
      bool hasUnreadNotification});
}

/// @nodoc
class _$NotificationStateCopyWithImpl<$Res, $Val extends NotificationState>
    implements $NotificationStateCopyWith<$Res> {
  _$NotificationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? allNotifications = null,
    Object? onlyNewNotifications = null,
    Object? showNewOnly = null,
    Object? hasUnreadNotification = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      allNotifications: null == allNotifications
          ? _value.allNotifications
          : allNotifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationModel>,
      onlyNewNotifications: null == onlyNewNotifications
          ? _value.onlyNewNotifications
          : onlyNewNotifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationModel>,
      showNewOnly: null == showNewOnly
          ? _value.showNewOnly
          : showNewOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      hasUnreadNotification: null == hasUnreadNotification
          ? _value.hasUnreadNotification
          : hasUnreadNotification // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationStateImplCopyWith<$Res>
    implements $NotificationStateCopyWith<$Res> {
  factory _$$NotificationStateImplCopyWith(_$NotificationStateImpl value,
          $Res Function(_$NotificationStateImpl) then) =
      __$$NotificationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<NotificationModel> allNotifications,
      List<NotificationModel> onlyNewNotifications,
      bool showNewOnly,
      bool hasUnreadNotification});
}

/// @nodoc
class __$$NotificationStateImplCopyWithImpl<$Res>
    extends _$NotificationStateCopyWithImpl<$Res, _$NotificationStateImpl>
    implements _$$NotificationStateImplCopyWith<$Res> {
  __$$NotificationStateImplCopyWithImpl(_$NotificationStateImpl _value,
      $Res Function(_$NotificationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? allNotifications = null,
    Object? onlyNewNotifications = null,
    Object? showNewOnly = null,
    Object? hasUnreadNotification = null,
  }) {
    return _then(_$NotificationStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      allNotifications: null == allNotifications
          ? _value._allNotifications
          : allNotifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationModel>,
      onlyNewNotifications: null == onlyNewNotifications
          ? _value._onlyNewNotifications
          : onlyNewNotifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationModel>,
      showNewOnly: null == showNewOnly
          ? _value.showNewOnly
          : showNewOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      hasUnreadNotification: null == hasUnreadNotification
          ? _value.hasUnreadNotification
          : hasUnreadNotification // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NotificationStateImpl extends _NotificationState {
  const _$NotificationStateImpl(
      {this.isLoading = false,
      final List<NotificationModel> allNotifications = const [],
      final List<NotificationModel> onlyNewNotifications = const [],
      this.showNewOnly = false,
      this.hasUnreadNotification = false})
      : _allNotifications = allNotifications,
        _onlyNewNotifications = onlyNewNotifications,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  final List<NotificationModel> _allNotifications;
  @override
  @JsonKey()
  List<NotificationModel> get allNotifications {
    if (_allNotifications is EqualUnmodifiableListView)
      return _allNotifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allNotifications);
  }

  final List<NotificationModel> _onlyNewNotifications;
  @override
  @JsonKey()
  List<NotificationModel> get onlyNewNotifications {
    if (_onlyNewNotifications is EqualUnmodifiableListView)
      return _onlyNewNotifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_onlyNewNotifications);
  }

  @override
  @JsonKey()
  final bool showNewOnly;
  @override
  @JsonKey()
  final bool hasUnreadNotification;

  @override
  String toString() {
    return 'NotificationState(isLoading: $isLoading, allNotifications: $allNotifications, onlyNewNotifications: $onlyNewNotifications, showNewOnly: $showNewOnly, hasUnreadNotification: $hasUnreadNotification)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._allNotifications, _allNotifications) &&
            const DeepCollectionEquality()
                .equals(other._onlyNewNotifications, _onlyNewNotifications) &&
            (identical(other.showNewOnly, showNewOnly) ||
                other.showNewOnly == showNewOnly) &&
            (identical(other.hasUnreadNotification, hasUnreadNotification) ||
                other.hasUnreadNotification == hasUnreadNotification));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_allNotifications),
      const DeepCollectionEquality().hash(_onlyNewNotifications),
      showNewOnly,
      hasUnreadNotification);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationStateImplCopyWith<_$NotificationStateImpl> get copyWith =>
      __$$NotificationStateImplCopyWithImpl<_$NotificationStateImpl>(
          this, _$identity);
}

abstract class _NotificationState extends NotificationState {
  const factory _NotificationState(
      {final bool isLoading,
      final List<NotificationModel> allNotifications,
      final List<NotificationModel> onlyNewNotifications,
      final bool showNewOnly,
      final bool hasUnreadNotification}) = _$NotificationStateImpl;
  const _NotificationState._() : super._();

  @override
  bool get isLoading;
  @override
  List<NotificationModel> get allNotifications;
  @override
  List<NotificationModel> get onlyNewNotifications;
  @override
  bool get showNewOnly;
  @override
  bool get hasUnreadNotification;
  @override
  @JsonKey(ignore: true)
  _$$NotificationStateImplCopyWith<_$NotificationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
