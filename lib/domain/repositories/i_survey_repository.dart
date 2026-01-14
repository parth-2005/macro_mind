import '../../domain/entities/survey_entity.dart';

abstract class ISurveyRepository {
  /// Fetches all active surveys from Firestore
  Future<List<SurveyEntity>> getActiveSurveys();

  /// Submits survey answers and returns the reward points earned
  Future<int> submitSurveyResponse(
    String surveyId,
    Map<String, dynamic> answers,
  );
}
