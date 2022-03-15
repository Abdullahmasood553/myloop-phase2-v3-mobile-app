// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_counter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationCounter _$NotificationCounterFromJson(Map<String, dynamic> json) =>
    NotificationCounter(
      count: json['count'] as int,
      surveyCount: json['surveyCount'] as int,
      pollCount: json['pollCount'] as int,
    );

Map<String, dynamic> _$NotificationCounterToJson(
        NotificationCounter instance) =>
    <String, dynamic>{
      'count': instance.count,
      'surveyCount': instance.surveyCount,
      'pollCount': instance.pollCount,
    };
