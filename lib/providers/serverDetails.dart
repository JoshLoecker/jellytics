// Freezed
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Riverpod
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Additional imports
import 'package:jellytics/utils/storage.dart' as storage;

part 'serverDetails.freezed.dart';
part 'serverDetails.g.dart';

@freezed
class ServerData with _$ServerData {
  factory ServerData({
    required String protocol,
    required String ipAddress,
    required String port,
    required String fullAddress,
    required String userId,
    required String username,
    required String accessToken,
  }) = _ServerData;
}

@riverpod
class ServerDetails extends _$ServerDetails {
  @override
  ServerData build() {
    return ServerData(
      protocol: "http://",
      ipAddress: "",
      port: "",
      fullAddress: "",
      userId: "",
      username: "",
      accessToken: "",
    );
  }

  // ----- Setters -----
  set protocol(String protocol_) {
    state = state.copyWith(protocol: protocol_);
  }

  set ipAddress(String ipAddress_) {
    state = state.copyWith(ipAddress: ipAddress_);
  }

  set port(String port_) {
    state = state.copyWith(port: port_);
  }

  set fullAddress(String fullAddress_) {
    state = state.copyWith(fullAddress: fullAddress_);
  }

  set userId(String userId_) {
    state = state.copyWith(userId: userId_);
  }

  set username(String username) {
    state = state.copyWith(username: username);
  }

  set accessToken(String accessToken) {
    state = state.copyWith(accessToken: accessToken);
  }

  // ----- Getters -----
  String get protocol => state.protocol;
  String get ipAddress => state.ipAddress;
  String get port => state.port;
  String get fullAddress => state.fullAddress;
  String get userId => state.userId;
  String get username => state.username;
  String get accessToken => state.accessToken;

  // ----- Other -----
  void logout() {
    state = state.copyWith(
      protocol: "http://",
      ipAddress: "",
      port: "",
      fullAddress: "",
      userId: "",
      username: "",
      accessToken: "",
    );
  }

  Future<void> saveData() async {
    await storage.storeServerIP(state.ipAddress);
    await storage.storeServerPort(state.port);
    await storage.storeServerProtocol(state.protocol);
    await storage.storeUserId(state.userId);
    await storage.storeUsername(state.username);
  }
}
