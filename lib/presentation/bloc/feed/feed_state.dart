import 'package:equatable/equatable.dart';
import '../../../domain/entities/card_entity.dart';

/// Feed States
abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final List<CardEntity> cards;
  final int currentIndex;
  final int totalSwipes;

  const FeedLoaded({
    required this.cards,
    this.currentIndex = 0,
    this.totalSwipes = 0,
  });

  FeedLoaded copyWith({
    List<CardEntity>? cards,
    int? currentIndex,
    int? totalSwipes,
  }) {
    return FeedLoaded(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      totalSwipes: totalSwipes ?? this.totalSwipes,
    );
  }

  @override
  List<Object?> get props => [cards, currentIndex, totalSwipes];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object?> get props => [message];
}

class FeedEmpty extends FeedState {
  final int totalSwipes;

  const FeedEmpty({required this.totalSwipes});

  @override
  List<Object?> get props => [totalSwipes];
}
