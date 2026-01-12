import '../entities/user_entity.dart';

/// Repository contract for authentication operations
/// Defines the interface that data layer must implement
abstract class IAuthRepository {
  /// Sign in with Google account
  /// Opens Google Sign-In flow and returns authenticated UserEntity
  Future<UserEntity> signInWithGoogle();

  /// Sign out the current user
  Future<void> signOut();

  /// Stream of authentication state changes
  /// Emits null when user is signed out, UserEntity when signed in
  Stream<UserEntity?> get user;

  /// Get the current authenticated user (synchronous)
  /// Returns null if no user is signed in
  UserEntity? get currentUser;
}
