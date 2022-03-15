// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_participants.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotificationParticipants _$PushNotificationParticipantsFromJson(
        Map<String, dynamic> json) =>
    PushNotificationParticipants(
      itemKey: json['itemKey'] as String,
      recipientRole: json['recipientRole'] as String,
      lastName: json['lastName'] as String,
      employeeNumber: json['employeeNumber'] as String,
    );

Map<String, dynamic> _$PushNotificationParticipantsToJson(
        PushNotificationParticipants instance) =>
    <String, dynamic>{
      'itemKey': instance.itemKey,
      'recipientRole': instance.recipientRole,
      'lastName': instance.lastName,
      'employeeNumber': instance.employeeNumber,
    };
