import 'package:equatable/equatable.dart';

/// Represents a market research card/question
/// Pure domain entity - no JSON serialization logic
class CardEntity extends Equatable {
  final String id;
  final String question;
  final String? imageUrl;
  final String category;
  final DateTime createdAt;

  const CardEntity({
    required this.id,
    required this.question,
    this.imageUrl,
    required this.category,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, question, imageUrl, category, createdAt];

  @override
  String toString() =>
      'CardEntity(id: $id, question: $question, category: $category)';
}
