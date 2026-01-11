import '../entities/card_entity.dart';
import '../entities/interaction_entity.dart';

/// Repository contract for card operations
/// Defines the interface that data layer must implement
abstract class ICardRepository {
  /// Fetches a list of market research cards
  Future<List<CardEntity>> getCards();

  /// Submits a user interaction with biometric data
  /// The repository sends raw data to server for trust score calculation
  Future<void> submitInteraction(String cardId, InteractionEntity interaction);

  /// Optional: Get user's interaction history
  Future<List<InteractionEntity>> getUserInteractions();
}
