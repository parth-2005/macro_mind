import 'package:equatable/equatable.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object?> get props => [];
}

class LoadSurveys extends SurveyEvent {}

class SubmitSurvey extends SurveyEvent {
  final String surveyId;
  final Map<String, dynamic> answers;

  const SubmitSurvey(this.surveyId, this.answers);

  @override
  List<Object?> get props => [surveyId, answers];
}
