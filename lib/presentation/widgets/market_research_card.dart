import 'package:flutter/material.dart';
import '../../../domain/entities/card_entity.dart';

/// Market Research Card Widget
class MarketResearchCard extends StatelessWidget {
  final CardEntity card;

  const MarketResearchCard({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(
                color: theme.dividerTheme.color ?? Colors.grey.shade800,
                width: 0.5,
              )
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              card.category.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Question
          Expanded(
            child: Center(
              child: Text(
                card.question,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Swipe Instructions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SwipeIndicator(
                icon: Icons.close_rounded,
                label: 'No',
                color: Colors.red.shade400,
              ),
              _SwipeIndicator(
                icon: Icons.check_rounded,
                label: 'Yes',
                color: Colors.green.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwipeIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SwipeIndicator({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color.withOpacity(0.6), size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color.withOpacity(0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
