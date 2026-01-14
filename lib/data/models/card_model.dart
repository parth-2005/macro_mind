import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/card_entity.dart';

/// Data model for CardEntity with JSON serialization
class CardModel extends CardEntity {
  const CardModel({
    required super.id,
    required super.question,
    super.imageUrl,
    super.imageLeftUrl,
    super.imageRightUrl,
    super.audioUrl,
    required super.category,
    required super.createdAt,
  });

  /// Safe date parser that handles Firestore Timestamp, String, or fallback
  static DateTime _parseDate(dynamic date) {
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.parse(date);
    return DateTime.now(); // Fallback for missing/null dates
  }

  /// Create from domain entity
  factory CardModel.fromEntity(CardEntity entity) {
    return CardModel(
      id: entity.id,
      question: entity.question,
      imageUrl: entity.imageUrl,
      imageLeftUrl: entity.imageLeftUrl,
      imageRightUrl: entity.imageRightUrl,
      audioUrl: entity.audioUrl,
      category: entity.category,
      createdAt: entity.createdAt,
    );
  }

  /// Create from JSON (API response) - handles both Timestamp and String formats
  factory CardModel.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'] as String? ?? 'unknown';
      debugPrint('[CardModel] Parsing JSON for ID: $id');

      return CardModel(
        id: id,
        question: json['question'] as String? ?? 'No question provided',
        imageUrl: json['imageUrl'] as String?,
        imageLeftUrl: json['imageLeftUrl'] as String?,
        imageRightUrl: json['imageRightUrl'] as String?,
        audioUrl: json['audioUrl'] as String?,
        category: json['category'] as String? ?? 'General',
        createdAt: _parseDate(json['createdAt']),
      );
    } catch (e) {
      debugPrint('[CardModel] CRITICAL: Failed to parse Card JSON: $e');
      debugPrint('[CardModel] problematic JSON: $json');
      rethrow;
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'imageUrl': imageUrl,
      'imageLeftUrl': imageLeftUrl,
      'imageRightUrl': imageRightUrl,
      'audioUrl': audioUrl,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
