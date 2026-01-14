import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';

/// Firebase Implementation of IAuthRepository
class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuthRepository(this._firebaseAuth, this._googleSignIn);

  @override
  Stream<UserEntity?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _mapFirebaseUserToEntity(firebaseUser);
    });
  }

  @override
  UserEntity? get currentUser {
    // Note: This won't have updated points immediately if using a sync getter.
    // In a real app, you'd want a Stream or a refresh mechanism.
    return null; // Force use of the Stream for points sync
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.authenticate();

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

      return await _mapFirebaseUserToEntity(firebaseUser);
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
  Future<UserEntity> _mapFirebaseUserToEntity(User firebaseUser) async {
    final userDoc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    int points = 0;
    if (userDoc.exists) {
      points = userDoc.data()?['points'] as int? ?? 0;
    } else {
      // Create user document if it doesn't exist
      await _firestore.collection('users').doc(firebaseUser.uid).set({
        'email': firebaseUser.email,
        'displayName': firebaseUser.displayName,
        'points': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      points: points,
      isAnonymous: firebaseUser.isAnonymous,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }
}
