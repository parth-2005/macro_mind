import 'package:equatable/equatable.dart';

/// Represents an authenticated user in the domain layer
class UserEntity extends Equatable {
  /// Unique identifier from Firebase Auth
  final String id;

  /// User's email address (from Google account)
  final String? email;

  /// User's display name (from Google account)
  final String? displayName;

  /// User's profile photo URL (from Google account)
  final String? photoUrl;

  /// Whether this is an anonymous user (no email/password)
  final bool isAnonymous;

  /// User's points for rewards
  final int points;

  /// When the user was created
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.points = 0,
    required this.isAnonymous,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    points,
    isAnonymous,
    createdAt,
  ];

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, displayName: $displayName, isAnonymous: $isAnonymous)';
  }
}
