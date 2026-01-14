import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../../domain/entities/card_entity.dart';

/// Market Research Card Widget - Clean Mass-Market Style
class MarketResearchCard extends StatelessWidget {
  final CardEntity card;

  const MarketResearchCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: AppTheme.cardDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Top Section (Category)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              card.category.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.primaryBlue,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // 2. Question Content (The Hero)
          Expanded(
            child: Center(
              child: Text(
                card.question,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
          ),

          // 3. Bottom Section (Affordance Hints)
          Column(
            children: [
              const Divider(color: AppTheme.borderLight, height: 1),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InteractionHint(
                    icon: Icons.close_rounded,
                    label: 'Disagree',
                    color: AppTheme.noColor,
                  ),
                  _InteractionHint(
                    icon: Icons.check_rounded,
                    label: 'Agree',
                    color: AppTheme.yesColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InteractionHint extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InteractionHint({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Icon(icon, color: color.withOpacity(0.7), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
