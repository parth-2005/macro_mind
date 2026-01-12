import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/i_auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing authentication state
/// Handles Google Sign-In flow
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  StreamSubscription<dynamic>? _authSubscription;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<SignOutRequested>(_onSignOutRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Listen to auth state changes
      _authSubscription?.cancel();
      _authSubscription = authRepository.user.listen((user) {
        add(AuthUserChanged(user));
      });

      // Check if user is already signed in
      final currentUser = authRepository.currentUser;

      if (currentUser != null) {
        debugPrint(
          '[AuthBloc] User already authenticated: ${currentUser.email}',
        );
        emit(AuthAuthenticated(currentUser));
      } else {
        // No user signed in - show login screen
        debugPrint('[AuthBloc] No user signed in, showing login screen');
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('[AuthBloc] Auth check failed: $e');
      emit(AuthError('Authentication failed: $e'));
    }
  }

  Future<void> _onSignInWithGoogleRequested(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      debugPrint('[AuthBloc] Google Sign-In requested');
      final user = await authRepository.signInWithGoogle();
      debugPrint('[AuthBloc] Google Sign-In successful: ${user.email}');
      emit(AuthAuthenticated(user));
    } catch (e) {
      debugPrint('[AuthBloc] Google Sign-In failed: $e');
      final errorMessage = e.toString().contains('cancelled')
          ? 'Sign in cancelled'
          : 'Failed to sign in: $e';
      emit(AuthError(errorMessage));

      // Return to unauthenticated state to show login screen again
      await Future.delayed(const Duration(seconds: 2));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      debugPrint('[AuthBloc] User changed: ${event.user!.email}');
      emit(AuthAuthenticated(event.user!));
    } else {
      debugPrint('[AuthBloc] User signed out');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint('[AuthBloc] Sign out requested');
      await authRepository.signOut();
      // State will be updated via AuthUserChanged event from stream
    } catch (e) {
      debugPrint('[AuthBloc] Sign out failed: $e');
      emit(AuthError('Sign out failed: $e'));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
