import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents biometric interaction data captured during card swipe
/// Contains raw sensor data for server-side "Ghost Protocol" analysis
class InteractionEntity extends Equatable {
  /// The exact path of the touch gesture
  /// Bots move in straight lines, humans create natural arcs
  final List<Offset> touchPath;

  /// Gyroscope variance during the swipe
  /// Zero variance indicates emulator/bot
  final double gyroVariance;

  /// Time (in milliseconds) between card display and first touch
  /// Measures decision hesitation - humans take time to think
  final int hesitationMs;

  /// Timestamp when interaction occurred
  final DateTime timestamp;

  /// Whether user swiped right (Yes) or left (No)
  final bool swipedRight;

  const InteractionEntity({
    required this.touchPath,
    required this.gyroVariance,
    required this.hesitationMs,
    required this.timestamp,
    required this.swipedRight,
  });

  @override
  List<Object?> get props => [
    touchPath,
    gyroVariance,
    hesitationMs,
    timestamp,
    swipedRight,
  ];

  @override
  String toString() {
    return 'InteractionEntity('
        'touchPoints: ${touchPath.length}, '
        'gyroVariance: ${gyroVariance.toStringAsFixed(4)}, '
        'hesitation: ${hesitationMs}ms, '
        'swipedRight: $swipedRight)';
  }

  /// Calculate path linearity score (0 = straight line, 1 = natural curve)
  /// This is for display/debugging purposes only
  /// Actual trust scoring happens server-side
  double get pathCurvature {
    if (touchPath.length < 3) return 0.0;

    // Calculate average deviation from straight line
    final start = touchPath.first;
    final end = touchPath.last;
    double totalDeviation = 0.0;

    for (int i = 1; i < touchPath.length - 1; i++) {
      final point = touchPath[i];
      final expectedY =
          start.dy +
          (point.dx - start.dx) * (end.dy - start.dy) / (end.dx - start.dx);
      totalDeviation += (point.dy - expectedY).abs();
    }

    return (totalDeviation / touchPath.length).clamp(0.0, 1.0);
  }
}
