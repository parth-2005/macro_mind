import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

/// Authentication Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered on app start to check authentication status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Triggered when auth state changes (user signed in/out)
class AuthUserChanged extends AuthEvent {
  final UserEntity? user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

/// Triggered when user requests to sign out
class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

/// Triggered when user requests to sign in with Google
class SignInWithGoogleRequested extends AuthEvent {
  const SignInWithGoogleRequested();
}
