// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ClientData {
  Dio get dio => throw _privateConstructorUsedError;
  bool get isLoggedIn => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClientDataCopyWith<ClientData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientDataCopyWith<$Res> {
  factory $ClientDataCopyWith(
          ClientData value, $Res Function(ClientData) then) =
      _$ClientDataCopyWithImpl<$Res, ClientData>;
  @useResult
  $Res call({Dio dio, bool isLoggedIn, String username, String userId});
}

/// @nodoc
class _$ClientDataCopyWithImpl<$Res, $Val extends ClientData>
    implements $ClientDataCopyWith<$Res> {
  _$ClientDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dio = null,
    Object? isLoggedIn = null,
    Object? username = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      dio: null == dio
          ? _value.dio
          : dio // ignore: cast_nullable_to_non_nullable
              as Dio,
      isLoggedIn: null == isLoggedIn
          ? _value.isLoggedIn
          : isLoggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ClientDataCopyWith<$Res>
    implements $ClientDataCopyWith<$Res> {
  factory _$$_ClientDataCopyWith(
          _$_ClientData value, $Res Function(_$_ClientData) then) =
      __$$_ClientDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Dio dio, bool isLoggedIn, String username, String userId});
}

/// @nodoc
class __$$_ClientDataCopyWithImpl<$Res>
    extends _$ClientDataCopyWithImpl<$Res, _$_ClientData>
    implements _$$_ClientDataCopyWith<$Res> {
  __$$_ClientDataCopyWithImpl(
      _$_ClientData _value, $Res Function(_$_ClientData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dio = null,
    Object? isLoggedIn = null,
    Object? username = null,
    Object? userId = null,
  }) {
    return _then(_$_ClientData(
      dio: null == dio
          ? _value.dio
          : dio // ignore: cast_nullable_to_non_nullable
              as Dio,
      isLoggedIn: null == isLoggedIn
          ? _value.isLoggedIn
          : isLoggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ClientData implements _ClientData {
  _$_ClientData(
      {required this.dio,
      required this.isLoggedIn,
      required this.username,
      required this.userId});

  @override
  final Dio dio;
  @override
  final bool isLoggedIn;
  @override
  final String username;
  @override
  final String userId;

  @override
  String toString() {
    return 'ClientData(dio: $dio, isLoggedIn: $isLoggedIn, username: $username, userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ClientData &&
            (identical(other.dio, dio) || other.dio == dio) &&
            (identical(other.isLoggedIn, isLoggedIn) ||
                other.isLoggedIn == isLoggedIn) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, dio, isLoggedIn, username, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ClientDataCopyWith<_$_ClientData> get copyWith =>
      __$$_ClientDataCopyWithImpl<_$_ClientData>(this, _$identity);
}

abstract class _ClientData implements ClientData {
  factory _ClientData(
      {required final Dio dio,
      required final bool isLoggedIn,
      required final String username,
      required final String userId}) = _$_ClientData;

  @override
  Dio get dio;
  @override
  bool get isLoggedIn;
  @override
  String get username;
  @override
  String get userId;
  @override
  @JsonKey(ignore: true)
  _$$_ClientDataCopyWith<_$_ClientData> get copyWith =>
      throw _privateConstructorUsedError;
}
