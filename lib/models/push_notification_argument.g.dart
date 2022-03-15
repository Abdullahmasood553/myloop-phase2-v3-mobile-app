// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_argument.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotificationArgument _$PushNotificationArgumentFromJson(
        Map<String, dynamic> json) =>
    PushNotificationArgument(
      PushNotification.fromJson(
          json['pushNotification'] as Map<String, dynamic>),
      json['previousRoute'] as String?,
    );

Map<String, dynamic> _$PushNotificationArgumentToJson(
        PushNotificationArgument instance) =>
    <String, dynamic>{
      'pushNotification': instance.pushNotification,
      'previousRoute': instance.previousRoute,
    };
