import 'package:json_annotation/json_annotation.dart';
import 'package:loop_hr/models/answer_response.dart';

part 'survey_response.g.dart';

@JsonSerializable()
class SurveyResponse {
  final int oidSurvey;
  final List<AnswerResponse> answerList;

  SurveyResponse(this.oidSurvey, this.answerList);

  factory SurveyResponse.fromJson(Map<String, dynamic> json) => _$SurveyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SurveyResponseToJson(this);
}
