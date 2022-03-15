import 'package:equatable/equatable.dart';

class SurveyEvent extends Equatable {
  List<Object> get props => [];
}

class FetchSurveyEvent extends SurveyEvent {

}

class CreateSurveyRequest extends SurveyEvent{
  final Map<String, dynamic> requestBody;
  CreateSurveyRequest(this.requestBody);
}
