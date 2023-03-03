/// This file is responsible for creating a riverpod provider that will watch the system brightness (light mode, dark mode)

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.freezed.dart';
part 'theme.g.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    required Brightness brightness,
    required Color themeColor,
    required Color invertedTheme,
  }) = _ThemeState;
}

@riverpod
class AppTheme extends _$AppTheme {
  set brightness(Brightness brightness_) {
    Color themeColor_ =
        brightness_ == Brightness.light ? Colors.white : Colors.black;
    Color invertedTheme_ =
        brightness_ == Brightness.light ? Colors.black : Colors.white;

    state = state.copyWith(
      brightness: brightness_,
      themeColor: themeColor_,
      invertedTheme: invertedTheme_,
    );
  }

  Brightness get brightness => state.brightness;
  Color get themeColor => state.themeColor;
  Color get invertedTheme => state.invertedTheme;
  Color get buttonColor => state.brightness == Brightness.dark
      ? const Color.fromRGBO(142, 142, 142, 1.0)
      : Colors.black;
  Color get buttonTextColor => Colors.white;

  @override
  ThemeState build() {
    Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
    Color themeColor =
        brightness == Brightness.light ? Colors.white : Colors.black;
    Color invertedTheme =
        brightness == Brightness.light ? Colors.black : Colors.white;
    return ThemeState(
      brightness: brightness,
      themeColor: themeColor,
      invertedTheme: invertedTheme,
    );
  }
}
