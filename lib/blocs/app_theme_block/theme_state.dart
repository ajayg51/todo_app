import 'package:flutter/material.dart';

abstract class ThemeState {}

class DummyThemeState extends ThemeState {}

class AppThemeState extends ThemeState {
  bool isLightTheme;
  AppThemeState({required this.isLightTheme});
}
