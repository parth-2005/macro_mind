import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/card_entity.dart';
import '../../domain/entities/interaction_entity.dart';
import '../../domain/repositories/card_repository.dart';
import '../../domain/repositories/i_auth_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/card_model.dart';
import '../models/interaction_model.dart';

/// Firestore implementation of ICardRepository
/// Connects to Firebase Cloud Firestore for real data
class FirestoreCardRepository implements ICardRepository {
  final FirebaseFirestore firestore;
  final IAuthRepository authRepository;

  FirestoreCardRepository({
    required this.firestore,
    required this.authRepository,
  });

  @override
  Future<List<CardEntity>> getCards() async {
    try {
      debugPrint('[FirestoreCardRepository] Fetching cards...');

      // CRITICAL: Order by orderIndex to ensure stable feed order
      final snapshot = await firestore
          .collection('cards')
          .orderBy('orderIndex')
          .get();

      // Safe mapping: skip invalid documents instead of crashing entire feed
      final cards = snapshot.docs
          .map((doc) {
            try {
              final data = doc.data();
              data['id'] = doc.id; // Add document ID to data
              return CardModel.fromJson(data);
            } catch (e) {
              debugPrint(
                '[FirestoreCardRepository] Error parsing doc ${doc.id}: $e',
              );
              return null; // Skip this document
            }
          })
          .whereType<CardModel>()
          .toList(); // Filter out nulls

      if (cards.isEmpty) {
        debugPrint(
          '[FirestoreCardRepository] WARNING: 0 cards found. Check if cards collection is empty OR missing orderIndex field.',
        );
      }

      debugPrint('[FirestoreCardRepository] Fetched ${cards.length} cards');
      return cards;
    } catch (e) {
      debugPrint('[FirestoreCardRepository] Error fetching cards: $e');
      throw Exception('Failed to load cards from Firestore: $e');
    }
  }

  @override
  Future<void> submitInteraction(
    String cardId,
    InteractionEntity interaction,
  ) async {
    try {
      final currentUser = authRepository.currentUser;

      if (currentUser == null) {
        debugPrint(
          '[FirestoreCardRepository] ABORT: No authenticated user found during interaction submission',
        );
        throw Exception('User must be authenticated to submit interaction');
      }

      debugPrint(
        '[FirestoreCardRepository] Submitting interaction for card: $cardId (User: ${currentUser.id})',
      );

      // Convert to model and get JSON
      final interactionModel = InteractionModel.fromEntity(interaction);
      final data = interactionModel.toJson();

      // Get dynamic version info
      final packageInfo = await PackageInfo.fromPlatform();
      final version = '${packageInfo.version}+${packageInfo.buildNumber}';

      // Enrich with security metadata
      final enrichedPayload = {
        ...data,
        'userId': currentUser.id, // CRITICAL: Include authenticated user ID
        'cardId': cardId,
        'timestamp':
            FieldValue.serverTimestamp(), // Server timestamp prevents manipulation
        'appVersion': version, // Dynamic versioning
      };

      // Submit to interactions collection
      await firestore.collection('interactions').add(enrichedPayload);

      debugPrint(
        '[FirestoreCardRepository] Interaction submitted successfully',
      );
    } catch (e) {
      debugPrint('[FirestoreCardRepository] Error submitting interaction: $e');
      throw Exception('Failed to submit interaction: $e');
    }
  }

  @override
  Future<List<InteractionEntity>> getUserInteractions() async {
    try {
      final currentUser = authRepository.currentUser;

      if (currentUser == null) {
        throw Exception('User must be authenticated to fetch interactions');
      }

      debugPrint('[FirestoreCardRepository] Fetching user interactions...');

      final snapshot = await firestore
          .collection('interactions')
          .where('userId', isEqualTo: currentUser.id)
          .orderBy('timestamp', descending: true)
          .get();

      // Safe mapping: skip invalid documents instead of crashing entire list
      final interactions = snapshot.docs
          .map((doc) {
            try {
              return InteractionModel.fromJson(doc.data());
            } catch (e) {
              debugPrint(
                '[FirestoreCardRepository] Error parsing interaction ${doc.id}: $e',
              );
              return null;
            }
          })
          .whereType<InteractionModel>()
          .toList();

      debugPrint(
        '[FirestoreCardRepository] Fetched ${interactions.length} interactions',
      );
      return interactions;
    } catch (e) {
      debugPrint('[FirestoreCardRepository] Error fetching interactions: $e');
      throw Exception('Failed to fetch user interactions: $e');
    }
  }
}
