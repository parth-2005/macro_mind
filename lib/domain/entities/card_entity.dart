import 'package:equatable/equatable.dart';

/// Represents a market research card/question
/// Pure domain entity - no JSON serialization logic
class CardEntity extends Equatable {
  final String id;
  final String question;
  final String? imageUrl;
  final String? imageLeftUrl;
  final String? imageRightUrl;
  final String? audioUrl;
  final String category;
  final DateTime createdAt;

  const CardEntity({
    required this.id,
    required this.question,
    this.imageUrl,
    this.imageLeftUrl,
    this.imageRightUrl,
    this.audioUrl,
    required this.category,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    question,
    imageUrl,
    imageLeftUrl,
    imageRightUrl,
    audioUrl,
    category,
    createdAt,
  ];

  @override
  String toString() =>
      'CardEntity(id: $id, question: $question, category: $category)';
}
