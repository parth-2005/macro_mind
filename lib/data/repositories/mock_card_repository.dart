import 'package:flutter/material.dart';
import '../../domain/entities/card_entity.dart';
import '../../domain/entities/interaction_entity.dart';
import '../../domain/repositories/card_repository.dart';
import '../models/card_model.dart';
import '../models/interaction_model.dart';

/// Mock implementation of ICardRepository
/// Simulates network latency and server-side biometric analysis
class MockCardRepository implements ICardRepository {
  final List<InteractionEntity> _interactionHistory = [];

  @override
  Future<List<CardEntity>> getCards() async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 800));

    // Return curated market research questions
    return _getMockCards();
  }

  @override
  Future<void> submitInteraction(
    String cardId,
    InteractionEntity interaction,
  ) async {
    // Convert to model for JSON serialization
    final interactionModel = InteractionModel.fromEntity(interaction);
    final jsonData = interactionModel.toJson();

    debugPrint('[MockRepository] Submitting interaction for card: $cardId');
    debugPrint('[MockRepository] Payload: $jsonData');

    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate server-side trust score calculation
    final trustScore = _calculateServerSideTrustScore(interaction);

    debugPrint(
      '[MockRepository] Server calculated trust score: ${trustScore.toStringAsFixed(2)}%',
    );

    if (trustScore < 50) {
      debugPrint(
        '[MockRepository] ⚠️  WARNING: Low trust score - possible bot activity',
      );
    } else if (trustScore > 80) {
      debugPrint('[MockRepository] ✅ High trust score - verified human');
    }

    // Store interaction history
    _interactionHistory.add(interaction);
  }

  @override
  Future<List<InteractionEntity>> getUserInteractions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_interactionHistory);
  }

  /// Simulates server-side trust score calculation
  /// In production, this would be a sophisticated ML model
  double _calculateServerSideTrustScore(InteractionEntity interaction) {
    double score = 50.0; // Base score

    // Factor 1: Path curvature (humans don't swipe in straight lines)
    final curvature = interaction.pathCurvature;
    if (curvature > 0.1) score += 20;
    if (curvature > 0.3) score += 10;

    // Factor 2: Gyroscope variance (emulators have zero variance)
    if (interaction.gyroVariance > 0.001) score += 15;
    if (interaction.gyroVariance > 0.01) score += 10;

    // Factor 3: Hesitation (bots respond instantly)
    if (interaction.hesitationMs > 200) score += 10;
    if (interaction.hesitationMs > 500) score += 5;

    // Factor 4: Touch point count (smooth natural gestures)
    if (interaction.touchPath.length > 10) score += 5;
    if (interaction.touchPath.length > 30) score += 5;

    return score.clamp(0, 100);
  }

  /// Generate mock market research cards
  List<CardEntity> _getMockCards() {
    final now = DateTime.now();

    return [
      CardModel(
        id: 'card_001',
        question:
            'Would you pay \$5/month for an ad-free social media experience?',
        category: 'Tech & Social Media',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      CardModel(
        id: 'card_002',
        question:
            'Should electric vehicles have a mandatory minimum sound at low speeds?',
        category: 'Automotive & Safety',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      CardModel(
        id: 'card_003',
        question: 'Would you trust AI to review your medical test results?',
        category: 'Healthcare & AI',
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      CardModel(
        id: 'card_004',
        question:
            'Should companies be required to disclose when you\'re chatting with a bot?',
        category: 'Ethics & Technology',
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      CardModel(
        id: 'card_005',
        question:
            'Would you use a "digital-only" bank with no physical branches?',
        category: 'Finance & Banking',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      CardModel(
        id: 'card_006',
        question:
            'Should social media platforms verify all users with government ID?',
        category: 'Privacy & Security',
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      CardModel(
        id: 'card_007',
        question: 'Would you attend virtual concerts in the metaverse?',
        category: 'Entertainment & VR',
        createdAt: now.subtract(const Duration(days: 1, hours: 8)),
      ),
      CardModel(
        id: 'card_008',
        question: 'Should flying cars be allowed in residential areas?',
        category: 'Future Transportation',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      CardModel(
        id: 'card_009',
        question:
            'Would you replace your traditional wallet with a chip implant?',
        category: 'Biohacking & Payments',
        createdAt: now.subtract(const Duration(days: 2, hours: 6)),
      ),
      CardModel(
        id: 'card_010',
        question:
            'Should AI-generated art be allowed in professional competitions?',
        category: 'Art & Creativity',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}
