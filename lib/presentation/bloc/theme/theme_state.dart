import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Theme State
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  const ThemeState.initial() : themeMode = ThemeMode.light;

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object?> get props => [themeMode];
}
