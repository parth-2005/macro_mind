import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';

/// Firebase Implementation of IAuthRepository
class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository(this._firebaseAuth, this._googleSignIn);

  @override
  Stream<UserEntity?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null
          ? null
          : _mapFirebaseUserToEntity(firebaseUser);
    });
  }

  @override
  UserEntity? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser == null ? null : _mapFirebaseUserToEntity(firebaseUser);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) {
        throw Exception('Google Sign-In aborted by user');
      }

      final googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase sign-in failed');
      }

      return _mapFirebaseUserToEntity(firebaseUser);
    } catch (e) {
      debugPrint('[FirebaseAuthRepository] Google Sign-In Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      debugPrint('[FirebaseAuthRepository] Sign-Out Error: $e');
      rethrow;
    }
  }

  /// Internal mapper to convert Firebase User to Domain Entity
  UserEntity _mapFirebaseUserToEntity(User firebaseUser) {
    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      isAnonymous: firebaseUser.isAnonymous,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }
}
