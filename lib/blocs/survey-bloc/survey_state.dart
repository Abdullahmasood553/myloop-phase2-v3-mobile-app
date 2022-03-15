import 'package:equatable/equatable.dart';
import 'package:loop_hr/models/survey.dart';

abstract class SurveyState extends Equatable {
  @override
  List<Object> get props => [];
}

class SurveyInitial extends SurveyState {}

class SurveyLoading extends SurveyState {}

class SurveyLoaded extends SurveyState {
  final List<Survey> surveyList;
  SurveyLoaded(this.surveyList);

  List<Object> get props => [surveyList];
}

class SurveyError extends SurveyState {
  final String message;
  SurveyError(this.message);
  List<Object> get props => [message];
}



class CreateSurveyLoading extends SurveyState {}

class CreateSurveySuccess extends SurveyState {
  final String message;
  CreateSurveySuccess(this.message);
  List<Object> get props => [message];
}

class CreateSurveyError extends SurveyState {
  final String message;
  CreateSurveyError(this.message);
}
