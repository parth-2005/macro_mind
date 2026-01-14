import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// Safe date parser that handles Firestore Timestamp, String, or fallback
  static DateTime _parseDate(dynamic date) {
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.parse(date);
    return DateTime.now(); // Fallback
  }

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

  /// Create from JSON (if needed for caching) - handles both Timestamp and String
  factory InteractionModel.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint('[InteractionModel] Parsing interaction JSON...');
      return InteractionModel(
        touchPath: (json['touchPath'] as List)
            .map((point) => Offset(point['x'] as double, point['y'] as double))
            .toList(),
        gyroVariance: (json['gyroVariance'] as num).toDouble(),
        hesitationMs: (json['hesitationMs'] as num).toInt(),
        timestamp: _parseDate(json['timestamp']),
        swipedRight: json['swipedRight'] as bool? ?? false,
      );
    } catch (e) {
      debugPrint('[InteractionModel] Error parsing Interaction JSON: $e');
      rethrow;
    }
  }
}
