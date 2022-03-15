// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyResponse _$SurveyResponseFromJson(Map<String, dynamic> json) =>
    SurveyResponse(
      json['oidSurvey'] as int,
      (json['answerList'] as List<dynamic>)
          .map((e) => AnswerResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SurveyResponseToJson(SurveyResponse instance) =>
    <String, dynamic>{
      'oidSurvey': instance.oidSurvey,
      'answerList': instance.answerList,
    };
