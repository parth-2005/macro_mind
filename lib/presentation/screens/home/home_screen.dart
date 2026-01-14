import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/di/injection.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/feed/feed_bloc.dart';
import '../../bloc/feed/feed_event.dart';
import '../../bloc/feed/feed_state.dart';
import '../../widgets/market_research_card.dart';
import '../../widgets/background_grid.dart';

/// Feed Screen - Clean Mass-Market Feed Interface
class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final CardSwiperController _swiperController = CardSwiperController();
  late final BiometricService _biometricService;

  @override
  void initState() {
    super.initState();
    _biometricService = getIt<BiometricService>();
    context.read<FeedBloc>().add(const LoadCards());
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundGrid(
      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is FeedLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is FeedError) {
                        return _buildErrorState(context, state);
                      }
                      if (state is FeedEmpty) {
                        return _buildEmptyState(context, state);
                      }
                      if (state is FeedLoaded) {
                        return _buildFeed(context, state);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeed(BuildContext context, FeedLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Listener(
        onPointerDown: (details) =>
            _biometricService.recordTouchPoint(details.localPosition),
        onPointerMove: (details) =>
            _biometricService.recordTouchPoint(details.localPosition),
        child: CardSwiper(
          key: ValueKey('swiper_${state.currentIndex}'),
          controller: _swiperController,
          cardsCount: state.cards.length - state.currentIndex,
          numberOfCardsDisplayed: (state.cards.length - state.currentIndex)
              .clamp(1, 2),
          backCardOffset: const Offset(0.0, 30.0),
          padding: EdgeInsets.zero,
          duration: const Duration(milliseconds: 400),
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
            final actualIndex = state.currentIndex + index;
            if (actualIndex >= state.cards.length) {
              return const SizedBox.shrink();
            }
            final card = state.cards[actualIndex];

            return Stack(
              children: [
                MarketResearchCard(card: card),
                if (percentThresholdX != 0 || percentThresholdY != 0)
                  _SwipeOverlay(
                    percentX: percentThresholdX,
                    percentY: percentThresholdY,
                  ),
              ],
            );
          },
          onSwipe: (previousIndex, currentIndex, direction) {
            final actualIndex = state.currentIndex + previousIndex;
            if (actualIndex >= state.cards.length) return false;

            final card = state.cards[actualIndex];
            final swipedRight = direction == CardSwiperDirection.right;

            final interaction = _biometricService.stopRecording(
              swipedRight: swipedRight,
            );

            if (interaction != null) {
              context.read<FeedBloc>().add(
                SwipeCard(cardId: card.id, interaction: interaction),
              );
            }
            return true;
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, FeedError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppTheme.noColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.read<FeedBloc>().add(const LoadCards()),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, FeedEmpty state) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.yesColor,
              size: 64,
            ),
            const SizedBox(height: 24),
            Text(
              'All dossiers reviewed',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Thank you for participating in this research study.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            Text(
              'TOTAL RESPONSES: ${state.totalSwipes}',
              style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeOverlay extends StatelessWidget {
  final num percentX;
  final num percentY;

  const _SwipeOverlay({required this.percentX, required this.percentY});

  @override
  Widget build(BuildContext context) {
    final isRight = percentX > 0;
    final opacity = ((percentX.abs() * 2).clamp(0.0, 1.0)).toDouble();
    final color = isRight ? AppTheme.yesColor : AppTheme.noColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withOpacity(opacity * 0.1),
      ),
      child: Center(
        child: Opacity(
          opacity: opacity,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isRight ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  isRight ? 'AGREE' : 'DISAGREE',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
