// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerResponse _$AnswerResponseFromJson(Map<String, dynamic> json) =>
    AnswerResponse(
      oidQuestion: json['oidQuestion'] as int,
      oidChoice: json['oidChoice'] as int,
    );

Map<String, dynamic> _$AnswerResponseToJson(AnswerResponse instance) =>
    <String, dynamic>{
      'oidQuestion': instance.oidQuestion,
      'oidChoice': instance.oidChoice,
    };
