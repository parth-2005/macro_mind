import 'package:equatable/equatable.dart';

enum SurveyQuestionType { slider, text, binary }

/// Represents a single question within a survey
class SurveyQuestion extends Equatable {
  final String id;
  final String text;
  final SurveyQuestionType type;

  const SurveyQuestion({
    required this.id,
    required this.text,
    required this.type,
  });

  @override
  List<Object?> get props => [id, text, type];
}

/// Represents a high-value survey form
class SurveyEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final int rewardPoints;
  final List<SurveyQuestion> questions;

  const SurveyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.questions,
  });

  @override
  List<Object?> get props => [id, title, description, rewardPoints, questions];
}
