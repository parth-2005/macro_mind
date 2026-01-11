import 'package:flutter/material.dart';
import '../../domain/entities/interaction_entity.dart';

/// Data model for InteractionEntity with JSON serialization
class InteractionModel extends InteractionEntity {
  const InteractionModel({
    required super.touchPath,
    required super.gyroVariance,
    required super.hesitationMs,
    required super.timestamp,
    required super.swipedRight,
  });

  /// Create from domain entity
  factory InteractionModel.fromEntity(InteractionEntity entity) {
    return InteractionModel(
      touchPath: entity.touchPath,
      gyroVariance: entity.gyroVariance,
      hesitationMs: entity.hesitationMs,
      timestamp: entity.timestamp,
      swipedRight: entity.swipedRight,
    );
  }

  /// Convert to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'touchPath': touchPath.map((offset) {
        return {'x': offset.dx, 'y': offset.dy};
      }).toList(),
      'gyroVariance': gyroVariance,
      'hesitationMs': hesitationMs,
      'timestamp': timestamp.toIso8601String(),
      'swipedRight': swipedRight,
      'pathCurvature': pathCurvature, // Computed property for analysis
    };
  }

  /// Create from JSON (if needed for caching)
  factory InteractionModel.fromJson(Map<String, dynamic> json) {
    return InteractionModel(
      touchPath: (json['touchPath'] as List)
          .map((point) => Offset(point['x'] as double, point['y'] as double))
          .toList(),
      gyroVariance: json['gyroVariance'] as double,
      hesitationMs: json['hesitationMs'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      swipedRight: json['swipedRight'] as bool,
    );
  }
}
