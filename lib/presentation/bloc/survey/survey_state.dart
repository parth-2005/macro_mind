import 'package:equatable/equatable.dart';
import '../../../domain/entities/survey_entity.dart';

abstract class SurveyState extends Equatable {
  const SurveyState();

  @override
  List<Object?> get props => [];
}

class SurveyInitial extends SurveyState {}

class SurveyLoading extends SurveyState {}

class SurveyLoaded extends SurveyState {
  final List<SurveyEntity> surveys;
  const SurveyLoaded(this.surveys);

  @override
  List<Object?> get props => [surveys];
}

class SurveySubmitting extends SurveyState {}

class SurveySuccess extends SurveyState {
  final int earnedPoints;
  const SurveySuccess(this.earnedPoints);

  @override
  List<Object?> get props => [earnedPoints];
}

class SurveyError extends SurveyState {
  final String message;
  const SurveyError(this.message);

  @override
  List<Object?> get props => [message];
}
