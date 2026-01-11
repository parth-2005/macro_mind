import 'package:equatable/equatable.dart';
import '../../../domain/entities/interaction_entity.dart';

/// Feed Events
abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadCards extends FeedEvent {
  const LoadCards();
}

class SwipeCard extends FeedEvent {
  final String cardId;
  final InteractionEntity interaction;

  const SwipeCard({required this.cardId, required this.interaction});

  @override
  List<Object?> get props => [cardId, interaction];
}

class CardDisplayed extends FeedEvent {
  const CardDisplayed();
}
