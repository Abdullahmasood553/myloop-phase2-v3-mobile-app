// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationComments _$NotificationCommentsFromJson(
        Map<String, dynamic> json) =>
    NotificationComments(
      itemKey: json['itemKey'] as String,
      commentDate:
          const DateTimeEpochConverter().fromJson(json['commentDate'] as int),
      notificationId: json['notificationId'] as int,
      fromUser: json['fromUser'] as String,
      action: json['action'] as String,
      userComment: json['userComment'] as String?,
    );

Map<String, dynamic> _$NotificationCommentsToJson(
        NotificationComments instance) =>
    <String, dynamic>{
      'itemKey': instance.itemKey,
      'commentDate':
          const DateTimeEpochConverter().toJson(instance.commentDate),
      'notificationId': instance.notificationId,
      'fromUser': instance.fromUser,
      'action': instance.action,
      'userComment': instance.userComment,
    };
