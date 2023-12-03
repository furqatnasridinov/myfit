// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RegistrationState {
  bool get isloading => throw _privateConstructorUsedError;
  bool get isPinCodeValidate => throw _privateConstructorUsedError;
  bool get isCodeError => throw _privateConstructorUsedError;
  int get timeToCountDown => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  bool get isValidPhone => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegistrationStateCopyWith<RegistrationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationStateCopyWith<$Res> {
  factory $RegistrationStateCopyWith(
          RegistrationState value, $Res Function(RegistrationState) then) =
      _$RegistrationStateCopyWithImpl<$Res, RegistrationState>;
  @useResult
  $Res call(
      {bool isloading,
      bool isPinCodeValidate,
      bool isCodeError,
      int timeToCountDown,
      String phoneNumber,
      bool isValidPhone});
}

/// @nodoc
class _$RegistrationStateCopyWithImpl<$Res, $Val extends RegistrationState>
    implements $RegistrationStateCopyWith<$Res> {
  _$RegistrationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isloading = null,
    Object? isPinCodeValidate = null,
    Object? isCodeError = null,
    Object? timeToCountDown = null,
    Object? phoneNumber = null,
    Object? isValidPhone = null,
  }) {
    return _then(_value.copyWith(
      isloading: null == isloading
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinCodeValidate: null == isPinCodeValidate
          ? _value.isPinCodeValidate
          : isPinCodeValidate // ignore: cast_nullable_to_non_nullable
              as bool,
      isCodeError: null == isCodeError
          ? _value.isCodeError
          : isCodeError // ignore: cast_nullable_to_non_nullable
              as bool,
      timeToCountDown: null == timeToCountDown
          ? _value.timeToCountDown
          : timeToCountDown // ignore: cast_nullable_to_non_nullable
              as int,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isValidPhone: null == isValidPhone
          ? _value.isValidPhone
          : isValidPhone // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationStateImplCopyWith<$Res>
    implements $RegistrationStateCopyWith<$Res> {
  factory _$$RegistrationStateImplCopyWith(_$RegistrationStateImpl value,
          $Res Function(_$RegistrationStateImpl) then) =
      __$$RegistrationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isloading,
      bool isPinCodeValidate,
      bool isCodeError,
      int timeToCountDown,
      String phoneNumber,
      bool isValidPhone});
}

/// @nodoc
class __$$RegistrationStateImplCopyWithImpl<$Res>
    extends _$RegistrationStateCopyWithImpl<$Res, _$RegistrationStateImpl>
    implements _$$RegistrationStateImplCopyWith<$Res> {
  __$$RegistrationStateImplCopyWithImpl(_$RegistrationStateImpl _value,
      $Res Function(_$RegistrationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isloading = null,
    Object? isPinCodeValidate = null,
    Object? isCodeError = null,
    Object? timeToCountDown = null,
    Object? phoneNumber = null,
    Object? isValidPhone = null,
  }) {
    return _then(_$RegistrationStateImpl(
      isloading: null == isloading
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinCodeValidate: null == isPinCodeValidate
          ? _value.isPinCodeValidate
          : isPinCodeValidate // ignore: cast_nullable_to_non_nullable
              as bool,
      isCodeError: null == isCodeError
          ? _value.isCodeError
          : isCodeError // ignore: cast_nullable_to_non_nullable
              as bool,
      timeToCountDown: null == timeToCountDown
          ? _value.timeToCountDown
          : timeToCountDown // ignore: cast_nullable_to_non_nullable
              as int,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isValidPhone: null == isValidPhone
          ? _value.isValidPhone
          : isValidPhone // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RegistrationStateImpl extends _RegistrationState {
  const _$RegistrationStateImpl(
      {this.isloading = false,
      this.isPinCodeValidate = false,
      this.isCodeError = false,
      this.timeToCountDown = 59,
      this.phoneNumber = "",
      this.isValidPhone = false})
      : super._();

  @override
  @JsonKey()
  final bool isloading;
  @override
  @JsonKey()
  final bool isPinCodeValidate;
  @override
  @JsonKey()
  final bool isCodeError;
  @override
  @JsonKey()
  final int timeToCountDown;
  @override
  @JsonKey()
  final String phoneNumber;
  @override
  @JsonKey()
  final bool isValidPhone;

  @override
  String toString() {
    return 'RegistrationState(isloading: $isloading, isPinCodeValidate: $isPinCodeValidate, isCodeError: $isCodeError, timeToCountDown: $timeToCountDown, phoneNumber: $phoneNumber, isValidPhone: $isValidPhone)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationStateImpl &&
            (identical(other.isloading, isloading) ||
                other.isloading == isloading) &&
            (identical(other.isPinCodeValidate, isPinCodeValidate) ||
                other.isPinCodeValidate == isPinCodeValidate) &&
            (identical(other.isCodeError, isCodeError) ||
                other.isCodeError == isCodeError) &&
            (identical(other.timeToCountDown, timeToCountDown) ||
                other.timeToCountDown == timeToCountDown) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.isValidPhone, isValidPhone) ||
                other.isValidPhone == isValidPhone));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isloading, isPinCodeValidate,
      isCodeError, timeToCountDown, phoneNumber, isValidPhone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationStateImplCopyWith<_$RegistrationStateImpl> get copyWith =>
      __$$RegistrationStateImplCopyWithImpl<_$RegistrationStateImpl>(
          this, _$identity);
}

abstract class _RegistrationState extends RegistrationState {
  const factory _RegistrationState(
      {final bool isloading,
      final bool isPinCodeValidate,
      final bool isCodeError,
      final int timeToCountDown,
      final String phoneNumber,
      final bool isValidPhone}) = _$RegistrationStateImpl;
  const _RegistrationState._() : super._();

  @override
  bool get isloading;
  @override
  bool get isPinCodeValidate;
  @override
  bool get isCodeError;
  @override
  int get timeToCountDown;
  @override
  String get phoneNumber;
  @override
  bool get isValidPhone;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationStateImplCopyWith<_$RegistrationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
