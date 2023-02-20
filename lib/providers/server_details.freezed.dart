// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ServerData {
  String get protocol => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  String get port => throw _privateConstructorUsedError;
  String get fullAddress => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ServerDataCopyWith<ServerData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerDataCopyWith<$Res> {
  factory $ServerDataCopyWith(
          ServerData value, $Res Function(ServerData) then) =
      _$ServerDataCopyWithImpl<$Res, ServerData>;
  @useResult
  $Res call(
      {String protocol,
      String ipAddress,
      String port,
      String fullAddress,
      String userId,
      String username,
      String accessToken});
}

/// @nodoc
class _$ServerDataCopyWithImpl<$Res, $Val extends ServerData>
    implements $ServerDataCopyWith<$Res> {
  _$ServerDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? protocol = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? fullAddress = null,
    Object? userId = null,
    Object? username = null,
    Object? accessToken = null,
  }) {
    return _then(_value.copyWith(
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
      fullAddress: null == fullAddress
          ? _value.fullAddress
          : fullAddress // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ServerDataCopyWith<$Res>
    implements $ServerDataCopyWith<$Res> {
  factory _$$_ServerDataCopyWith(
          _$_ServerData value, $Res Function(_$_ServerData) then) =
      __$$_ServerDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String protocol,
      String ipAddress,
      String port,
      String fullAddress,
      String userId,
      String username,
      String accessToken});
}

/// @nodoc
class __$$_ServerDataCopyWithImpl<$Res>
    extends _$ServerDataCopyWithImpl<$Res, _$_ServerData>
    implements _$$_ServerDataCopyWith<$Res> {
  __$$_ServerDataCopyWithImpl(
      _$_ServerData _value, $Res Function(_$_ServerData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? protocol = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? fullAddress = null,
    Object? userId = null,
    Object? username = null,
    Object? accessToken = null,
  }) {
    return _then(_$_ServerData(
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
      fullAddress: null == fullAddress
          ? _value.fullAddress
          : fullAddress // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ServerData with DiagnosticableTreeMixin implements _ServerData {
  _$_ServerData(
      {required this.protocol,
      required this.ipAddress,
      required this.port,
      required this.fullAddress,
      required this.userId,
      required this.username,
      required this.accessToken});

  @override
  final String protocol;
  @override
  final String ipAddress;
  @override
  final String port;
  @override
  final String fullAddress;
  @override
  final String userId;
  @override
  final String username;
  @override
  final String accessToken;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ServerData(protocol: $protocol, ipAddress: $ipAddress, port: $port, fullAddress: $fullAddress, userId: $userId, username: $username, accessToken: $accessToken)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ServerData'))
      ..add(DiagnosticsProperty('protocol', protocol))
      ..add(DiagnosticsProperty('ipAddress', ipAddress))
      ..add(DiagnosticsProperty('port', port))
      ..add(DiagnosticsProperty('fullAddress', fullAddress))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('username', username))
      ..add(DiagnosticsProperty('accessToken', accessToken));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ServerData &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.fullAddress, fullAddress) ||
                other.fullAddress == fullAddress) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken));
  }

  @override
  int get hashCode => Object.hash(runtimeType, protocol, ipAddress, port,
      fullAddress, userId, username, accessToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ServerDataCopyWith<_$_ServerData> get copyWith =>
      __$$_ServerDataCopyWithImpl<_$_ServerData>(this, _$identity);
}

abstract class _ServerData implements ServerData {
  factory _ServerData(
      {required final String protocol,
      required final String ipAddress,
      required final String port,
      required final String fullAddress,
      required final String userId,
      required final String username,
      required final String accessToken}) = _$_ServerData;

  @override
  String get protocol;
  @override
  String get ipAddress;
  @override
  String get port;
  @override
  String get fullAddress;
  @override
  String get userId;
  @override
  String get username;
  @override
  String get accessToken;
  @override
  @JsonKey(ignore: true)
  _$$_ServerDataCopyWith<_$_ServerData> get copyWith =>
      throw _privateConstructorUsedError;
}
