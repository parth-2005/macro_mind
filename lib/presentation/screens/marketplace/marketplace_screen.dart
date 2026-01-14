import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/reward/reward_bloc.dart';
import '../../bloc/reward/reward_event.dart';
import '../../bloc/reward/reward_state.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  bool _showTicket = false;

  @override
  void initState() {
    super.initState();
    context.read<RewardBloc>().add(const LoadRewards());
  }

  void _redeemReward(String id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Redemption'),
        content: Text('Are you sure you want to redeem "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RewardBloc>().add(RedeemReward(id));
            },
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RewardBloc, RewardState>(
      listener: (context, state) {
        if (state is RewardRedeemSuccess) {
          setState(() => _showTicket = true);
        } else if (state is RewardError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (_showTicket) {
          return GreenTicketView(
            onClose: () => setState(() => _showTicket = false),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Rewards',
              style: GoogleFonts.inter(fontWeight: FontWeight.w800),
            ),
          ),
          body: Builder(
            builder: (context) {
              if (state is RewardLoading || state is RewardRedeeming) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is RewardLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.rewards.length,
                  itemBuilder: (context, index) {
                    final reward = state.rewards[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () => _redeemReward(reward.id, reward.title),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.redeem,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reward.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${reward.cost} Pts',
                                    style: GoogleFonts.inter(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const Center(child: Text('Failed to load rewards'));
            },
          ),
        );
      },
    );
  }
}

class GreenTicketView extends StatefulWidget {
  final VoidCallback onClose;
  const GreenTicketView({super.key, required this.onClose});

  @override
  State<GreenTicketView> createState() => _GreenTicketViewState();
}

class _GreenTicketViewState extends State<GreenTicketView>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _secondsRemaining = 300;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return '00:00';
    final mins = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpired = _secondsRemaining <= 0;
    final Color baseColor = isExpired ? Colors.red : Colors.greenAccent[700]!;

    return Scaffold(
      backgroundColor: baseColor,
      body: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  baseColor.withValues(
                    alpha: isExpired ? 1.0 : _pulseAnimation.value,
                  ),
                  baseColor,
                ],
                radius: 1.5,
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isExpired ? Icons.error_outline : Icons.check_circle_outline,
                  size: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  isExpired ? 'EXPIRED' : 'VALID TICKET',
                  style: GoogleFonts.inter(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    _formatTime(_secondsRemaining),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 64),
                ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: baseColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(isExpired ? 'CLOSE' : 'BACK TO MARKET'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
