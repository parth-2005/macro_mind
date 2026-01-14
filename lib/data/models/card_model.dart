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

  /// Create from JSON (API response)
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      question: json['question'] as String,
      imageUrl: json['imageUrl'] as String?,
      imageLeftUrl: json['imageLeftUrl'] as String?,
      imageRightUrl: json['imageRightUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
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
