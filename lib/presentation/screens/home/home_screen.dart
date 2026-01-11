import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../../core/di/injection.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/feed/feed_bloc.dart';
import '../../bloc/feed/feed_event.dart';
import '../../bloc/feed/feed_state.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_event.dart';
import '../../bloc/theme/theme_state.dart';
import '../../widgets/market_research_card.dart';

/// Home Screen - Main Market Research Feed
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.poll_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            const Text('CrowdPulse'),
          ],
        ),
        actions: [
          // Theme Toggle
          IconButton(
            icon: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Icon(
                  state.themeMode == ThemeMode.light
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                );
              },
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(const ToggleTheme());
            },
            tooltip: 'Toggle Theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FeedError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<FeedBloc>().add(const LoadCards());
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is FeedEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 80,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'All Done!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You\'ve reviewed all available questions.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total responses: ${state.totalSwipes}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is FeedLoaded) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Progress Indicator
                    _ProgressBar(
                      current: state.currentIndex,
                      total: state.cards.length,
                    ),
                    const SizedBox(height: 16),

                    // Card Swiper
                    Expanded(
                      child: Listener(
                        onPointerDown: (details) {
                          _biometricService.recordTouchPoint(
                            details.localPosition,
                          );
                        },
                        onPointerMove: (details) {
                          _biometricService.recordTouchPoint(
                            details.localPosition,
                          );
                        },
                        child: CardSwiper(
                          key: ValueKey('swiper_${state.currentIndex}'),
                          controller: _swiperController,
                          cardsCount: state.cards.length - state.currentIndex,
                          numberOfCardsDisplayed:
                              (state.cards.length - state.currentIndex).clamp(
                                1,
                                2,
                              ),
                          backCardOffset: const Offset(0.0, 20.0),
                          padding: EdgeInsets.zero,
                          duration: const Duration(milliseconds: 300),
                          cardBuilder:
                              (
                                context,
                                index,
                                percentThresholdX,
                                percentThresholdY,
                              ) {
                                final actualIndex = state.currentIndex + index;

                                // Bounds check to prevent RangeError
                                if (actualIndex >= state.cards.length) {
                                  return const SizedBox.shrink();
                                }

                                final card = state.cards[actualIndex];

                                return Stack(
                                  children: [
                                    MarketResearchCard(card: card),

                                    // Swipe Overlay
                                    if (percentThresholdX != 0 ||
                                        percentThresholdY != 0)
                                      _SwipeOverlay(
                                        percentX: percentThresholdX,
                                        percentY: percentThresholdY,
                                      ),
                                  ],
                                );
                              },
                          onSwipe: (previousIndex, currentIndex, direction) {
                            final actualIndex =
                                state.currentIndex + previousIndex;

                            // Bounds check
                            if (actualIndex >= state.cards.length) {
                              debugPrint(
                                '[HomeScreen] Out of bounds: $actualIndex >= ${state.cards.length}',
                              );
                              return false;
                            }

                            final card = state.cards[actualIndex];
                            final swipedRight =
                                direction == CardSwiperDirection.right;

                            // Stop recording and get interaction data
                            final interaction = _biometricService.stopRecording(
                              swipedRight: swipedRight,
                            );

                            if (interaction != null) {
                              context.read<FeedBloc>().add(
                                SwipeCard(
                                  cardId: card.id,
                                  interaction: interaction,
                                ),
                              );
                            }

                            return true;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// Progress Bar Widget
class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = current.toDouble() / total.toDouble();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progress', style: Theme.of(context).textTheme.labelMedium),
            Text(
              '$current / $total',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Theme.of(context).dividerColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Swipe Overlay Widget
class _SwipeOverlay extends StatelessWidget {
  final num percentX;
  final num percentY;

  const _SwipeOverlay({required this.percentX, required this.percentY});

  @override
  Widget build(BuildContext context) {
    final isRight = percentX > 0;
    final opacity = ((percentX.abs() * 2).clamp(0.0, 1.0)).toDouble();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: isRight ? Alignment.centerLeft : Alignment.centerRight,
          end: isRight ? Alignment.centerRight : Alignment.centerLeft,
          colors: [
            (isRight ? AppTheme.yesColor : AppTheme.noColor).withOpacity(
              opacity * 0.3,
            ),
            (isRight ? AppTheme.yesColor : AppTheme.noColor).withOpacity(
              opacity * 0.1,
            ),
          ],
        ),
      ),
      child: Center(
        child: Opacity(
          opacity: opacity,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isRight ? AppTheme.yesColor : AppTheme.noColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isRight ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  isRight ? 'YES' : 'NO',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
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
