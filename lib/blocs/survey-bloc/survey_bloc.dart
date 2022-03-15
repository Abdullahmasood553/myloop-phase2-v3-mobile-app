import 'package:bloc/bloc.dart';
import 'package:loop_hr/blocs/survey-bloc/survey_event.dart';
import 'package:loop_hr/blocs/survey-bloc/survey_state.dart';
import 'package:loop_hr/models/survey.dart';
import 'package:loop_hr/repositories/survey_repository.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SurveyRepository repository;

  SurveyBloc(this.repository) : super(SurveyInitial()) {
    on<SurveyEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(SurveyEvent event, Emitter<SurveyState> emit) async {
    if (event is FetchSurveyEvent) {
      emit(CreateSurveyLoading());
      try {
        List<Survey> surveyList = await repository.findAllSurvey();
        emit(SurveyLoaded(surveyList));
      } catch (e) {
        emit(SurveyError(e.toString()));
      }
    } else if (event is CreateSurveyRequest) {
      emit(CreateSurveyLoading());
      try {
        await repository.createSurveyRequest(event.requestBody);
        emit(CreateSurveySuccess("Response has been submitted successfully"));
        List<Survey> surveyList = await repository.findAllSurvey();
        emit(SurveyLoaded(surveyList));
      } catch (e) {
        emit(CreateSurveySuccess(e.toString()));
      }
    }
  }
}
