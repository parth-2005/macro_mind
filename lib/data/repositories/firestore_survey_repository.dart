import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/survey_entity.dart';
import '../../domain/repositories/i_survey_repository.dart';
import '../../domain/repositories/i_auth_repository.dart';

class FirestoreSurveyRepository implements ISurveyRepository {
  final FirebaseFirestore _firestore;
  final IAuthRepository _authRepository;

  FirestoreSurveyRepository({
    FirebaseFirestore? firestore,
    required IAuthRepository authRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _authRepository = authRepository;

  @override
  Future<List<SurveyEntity>> getActiveSurveys() async {
    try {
      final snapshot = await _firestore
          .collection('surveys')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final questionsData = data['questions'] as List<dynamic>;

        final questions = questionsData.map((q) {
          final qMap = q as Map<String, dynamic>;
          SurveyQuestionType type;
          switch (qMap['type']) {
            case 'slider':
              type = SurveyQuestionType.slider;
              break;
            case 'binary':
            case 'yes_no':
              type = SurveyQuestionType.binary;
              break;
            default:
              type = SurveyQuestionType.text;
          }

          return SurveyQuestion(
            id: qMap['id'] as String,
            text: qMap['text'] as String,
            type: type,
          );
        }).toList();

        return SurveyEntity(
          id: doc.id,
          title: data['title'] as String,
          description: data['description'] as String,
          rewardPoints: data['rewardPoints'] as int,
          questions: questions,
        );
      }).toList();
    } catch (e) {
      debugPrint('[FirestoreSurveyRepository] Error fetching surveys: $e');
      return [];
    }
  }

  @override
  Future<int> submitSurveyResponse(
    String surveyId,
    Map<String, dynamic> answers,
  ) async {
    final user = _authRepository.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to submit survey');
    }

    try {
      final surveyDoc = await _firestore
          .collection('surveys')
          .doc(surveyId)
          .get();
      if (!surveyDoc.exists) throw Exception('Survey not found');

      final rewardPoints = surveyDoc.data()?['rewardPoints'] as int? ?? 0;

      // Use a batch to ensure atomicity
      final batch = _firestore.batch();

      // 1. Save response
      final responseRef = _firestore.collection('responses').doc();
      batch.set(responseRef, {
        'surveyId': surveyId,
        'userId': user.id,
        'answers': answers,
        'pointsEarned': rewardPoints,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      // 2. Increment user points
      final userRef = _firestore.collection('users').doc(user.id);
      batch.update(userRef, {'points': FieldValue.increment(rewardPoints)});

      await batch.commit();
      return rewardPoints;
    } catch (e) {
      debugPrint('[FirestoreSurveyRepository] Error submitting survey: $e');
      rethrow;
    }
  }
}
