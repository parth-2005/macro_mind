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

      debugPrint(
        '[FirestoreSurveyRepository] Found ${snapshot.docs.length} active surveys',
      );

      return snapshot.docs
          .map((doc) {
            try {
              final data = doc.data();
              debugPrint(
                '[FirestoreSurveyRepository] Parsing survey: ${data['title']} (ID: ${doc.id})',
              );

              final questionsData = data['questions'] as List<dynamic>? ?? [];

              final questions = questionsData.map((q) {
                final qMap = q as Map<String, dynamic>;

                // Map string type to enum
                SurveyQuestionType qType;
                final typeStr = qMap['type'] as String? ?? 'text';
                switch (typeStr) {
                  case 'slider':
                    qType = SurveyQuestionType.slider;
                    break;
                  case 'binary':
                    qType = SurveyQuestionType.binary;
                    break;
                  case 'multipleChoice':
                  case 'multiple_choice':
                    qType = SurveyQuestionType.multipleChoice;
                    break;
                  case 'rating':
                    qType = SurveyQuestionType.rating;
                    break;
                  case 'text':
                  default:
                    qType = SurveyQuestionType.text;
                }

                return SurveyQuestion(
                  id: qMap['id'] as String? ?? '',
                  text: qMap['text'] as String? ?? '',
                  type: qType,
                  options: (qMap['options'] as List?)
                      ?.map((e) => e.toString())
                      .toList(),
                );
              }).toList();

              return SurveyEntity(
                id: doc.id,
                title: data['title'] as String? ?? 'Untitled Survey',
                description: data['description'] as String? ?? '',
                rewardPoints: (data['rewardPoints'] as num?)?.toInt() ?? 0,
                questions: questions,
              );
            } catch (e) {
              debugPrint(
                '[FirestoreSurveyRepository] CRITICAL: Failed to parse survey doc ${doc.id}: $e',
              );
              return null;
            }
          })
          .whereType<SurveyEntity>()
          .toList();
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
