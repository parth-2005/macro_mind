import 'package:flutter/foundation.dart';
import '../../domain/entities/reward_entity.dart';

/// Data model for RewardEntity with JSON serialization
class RewardModel extends RewardEntity {
  const RewardModel({
    required super.id,
    required super.title,
    required super.cost,
    required super.imageUrl,
    required super.isDigital,
    required super.stock,
  });

  /// Create from domain entity
  factory RewardModel.fromEntity(RewardEntity entity) {
    return RewardModel(
      id: entity.id,
      title: entity.title,
      cost: entity.cost,
      imageUrl: entity.imageUrl,
      isDigital: entity.isDigital,
      stock: entity.stock,
    );
  }

  /// Create from JSON (API response)
  factory RewardModel.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'] as String? ?? 'unknown';
      debugPrint('[RewardModel] Parsing JSON for ID: $id');

      return RewardModel(
        id: id,
        title: json['title'] as String? ?? 'Untitled Reward',
        cost: (json['cost'] as num?)?.toInt() ?? 0,
        imageUrl: json['imageUrl'] as String? ?? '',
        isDigital: json['isDigital'] as bool? ?? true,
        stock: (json['stock'] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      debugPrint('[RewardModel] CRITICAL: Failed to parse Reward JSON: $e');
      debugPrint('[RewardModel] problematic JSON: $json');
      rethrow;
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cost': cost,
      'imageUrl': imageUrl,
      'isDigital': isDigital,
      'stock': stock,
    };
  }
}
