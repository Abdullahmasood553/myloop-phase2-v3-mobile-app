// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Survey _$SurveyFromJson(Map<String, dynamic> json) => Survey(
      oid: json['oid'] as int,
      topic: json['topic'] as String,
      startDate:
          const DateTimeEpochConverter().fromJson(json['startDate'] as int),
      endDate: const DateTimeEpochConverter().fromJson(json['endDate'] as int),
      creationDate:
          const DateTimeEpochConverter().fromJson(json['creationDate'] as int),
      active: json['active'] as bool,
      poll: json['poll'] as bool,
      questionList: (json['questionList'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SurveyToJson(Survey instance) => <String, dynamic>{
      'oid': instance.oid,
      'topic': instance.topic,
      'startDate': const DateTimeEpochConverter().toJson(instance.startDate),
      'endDate': const DateTimeEpochConverter().toJson(instance.endDate),
      'creationDate':
          const DateTimeEpochConverter().toJson(instance.creationDate),
      'active': instance.active,
      'poll': instance.poll,
      'questionList': instance.questionList,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      oid: json['oid'] as int,
      oidSurvey: json['oidSurvey'] as int,
      questionType: json['questionType'] as int,
      questionStatement: json['questionStatement'] as String,
      sortOrder: json['sortOrder'] as int,
      choiceList: (json['choiceList'] as List<dynamic>)
          .map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'oid': instance.oid,
      'oidSurvey': instance.oidSurvey,
      'questionType': instance.questionType,
      'questionStatement': instance.questionStatement,
      'sortOrder': instance.sortOrder,
      'choiceList': instance.choiceList,
    };

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      oid: json['oid'] as int,
      oidQuestion: json['oidQuestion'] as int,
      choiceStatement: json['choiceStatement'] as String,
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'oid': instance.oid,
      'oidQuestion': instance.oidQuestion,
      'choiceStatement': instance.choiceStatement,
    };
