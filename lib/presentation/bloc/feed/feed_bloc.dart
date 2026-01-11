import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/card_repository.dart';
import '../../../core/services/biometric_service.dart';
import 'feed_event.dart';
import 'feed_state.dart';

/// BLoC for managing card feed logic
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final ICardRepository cardRepository;
  final BiometricService biometricService;

  FeedBloc({required this.cardRepository, required this.biometricService})
    : super(const FeedInitial()) {
    on<LoadCards>(_onLoadCards);
    on<SwipeCard>(_onSwipeCard);
    on<CardDisplayed>(_onCardDisplayed);
  }

  Future<void> _onLoadCards(LoadCards event, Emitter<FeedState> emit) async {
    emit(const FeedLoading());

    try {
      final cards = await cardRepository.getCards();

      if (cards.isEmpty) {
        emit(const FeedEmpty(totalSwipes: 0));
      } else {
        emit(FeedLoaded(cards: cards));
        // Start recording for first card
        biometricService.startRecording();
      }
    } catch (e) {
      debugPrint('[FeedBloc] Error loading cards: $e');
      emit(FeedError('Failed to load cards: $e'));
    }
  }

  Future<void> _onSwipeCard(SwipeCard event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;

    final currentState = state as FeedLoaded;

    try {
      // Submit interaction to repository
      await cardRepository.submitInteraction(event.cardId, event.interaction);

      final newIndex = currentState.currentIndex + 1;
      final newSwipeCount = currentState.totalSwipes + 1;

      // Check if there are more cards
      if (newIndex >= currentState.cards.length) {
        emit(FeedEmpty(totalSwipes: newSwipeCount));
      } else {
        emit(
          currentState.copyWith(
            currentIndex: newIndex,
            totalSwipes: newSwipeCount,
          ),
        );

        // Start recording for next card
        biometricService.startRecording();
      }
    } catch (e) {
      debugPrint('[FeedBloc] Error submitting swipe: $e');
      emit(FeedError('Failed to submit interaction: $e'));
    }
  }

  Future<void> _onCardDisplayed(
    CardDisplayed event,
    Emitter<FeedState> emit,
  ) async {
    // Start recording when a new card is displayed
    biometricService.startRecording();
  }
}
