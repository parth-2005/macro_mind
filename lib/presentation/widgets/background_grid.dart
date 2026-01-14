import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Clean Neutral Background for Mass Market UI
class BackgroundGrid extends StatelessWidget {
  final Widget child;

  const BackgroundGrid({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark ? const Color(0xFF0F172A) : AppTheme.backgroundLight,
      child: Stack(
        children: [
          // Optional: Very subtle dot pattern/texture can be added here
          // For now, keeping it perfectly clean as per "Mass Market" specs

          // Content
          child,
        ],
      ),
    );
  }
}
