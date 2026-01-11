import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_event.dart';
import 'theme_state.dart';

/// BLoC for managing app theme (Light/Dark mode)
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeBloc() : super(const ThemeState.initial()) {
    on<LoadThemePreference>(_onLoadThemePreference);
    on<ToggleTheme>(_onToggleTheme);
    on<SetThemeMode>(_onSetThemeMode);

    // Load saved preference on initialization
    add(const LoadThemePreference());
  }

  Future<void> _onLoadThemePreference(
    LoadThemePreference event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeKey);

      if (themeModeString != null) {
        final themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.light,
        );
        emit(state.copyWith(themeMode: themeMode));
        debugPrint('[ThemeBloc] Loaded theme preference: $themeMode');
      }
    } catch (e) {
      debugPrint('[ThemeBloc] Error loading theme preference: $e');
    }
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final newThemeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(state.copyWith(themeMode: newThemeMode));
    await _saveThemePreference(newThemeMode);
    debugPrint('[ThemeBloc] Toggled to: $newThemeMode');
  }

  Future<void> _onSetThemeMode(
    SetThemeMode event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));
    await _saveThemePreference(event.themeMode);
    debugPrint('[ThemeBloc] Set theme to: ${event.themeMode}');
  }

  Future<void> _saveThemePreference(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, themeMode.toString());
    } catch (e) {
      debugPrint('[ThemeBloc] Error saving theme preference: $e');
    }
  }
}
