import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Theme Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
}

class SetThemeMode extends ThemeEvent {
  final ThemeMode themeMode;

  const SetThemeMode(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class LoadThemePreference extends ThemeEvent {
  const LoadThemePreference();
}
