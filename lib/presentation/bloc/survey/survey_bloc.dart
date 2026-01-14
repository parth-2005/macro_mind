import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/i_survey_repository.dart';
import 'survey_event.dart';
import 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final ISurveyRepository _surveyRepository;

  SurveyBloc({required ISurveyRepository surveyRepository})
    : _surveyRepository = surveyRepository,
      super(SurveyInitial()) {
    on<LoadSurveys>(_onLoadSurveys);
    on<SubmitSurvey>(_onSubmitSurvey);
  }

  Future<void> _onLoadSurveys(
    LoadSurveys event,
    Emitter<SurveyState> emit,
  ) async {
    emit(SurveyLoading());
    try {
      final surveys = await _surveyRepository.getActiveSurveys();
      emit(SurveyLoaded(surveys));
    } catch (e) {
      emit(SurveyError(e.toString()));
    }
  }

  Future<void> _onSubmitSurvey(
    SubmitSurvey event,
    Emitter<SurveyState> emit,
  ) async {
    emit(SurveySubmitting());
    try {
      final earnedPoints = await _surveyRepository.submitSurveyResponse(
        event.surveyId,
        event.answers,
      );
      emit(SurveySuccess(earnedPoints));
    } catch (e) {
      emit(SurveyError(e.toString()));
    }
  }
}
