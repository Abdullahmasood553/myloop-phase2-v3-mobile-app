// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotification _$PushNotificationFromJson(Map<String, dynamic> json) =>
    PushNotification(
      oid: json['oid'] as int,
      type: json['type'] as String,
      employeeNumber: json['employeeNumber'] as String,
      senderName: json['senderName'] as String,
      oidType: json['oidType'] as int,
      typeName: json['typeName'] as String,
      status: json['status'] as String,
      dateStart:
          const DateTimeEpochConverter().fromJson(json['dateStart'] as int),
      dateEnd: const DateTimeEpochConverter().fromJson(json['dateEnd'] as int),
      notificationDate: const DateTimeEpochConverter()
          .fromJson(json['notificationDate'] as int),
      timeStart: json['timeStart'] as String?,
      timeEnd: json['timeEnd'] as String?,
      fromCity: json['fromCity'] as String?,
      toCity: json['toCity'] as String?,
      absenceDays: (json['absenceDays'] as num?)?.toDouble(),
      absenceHours: (json['absenceHours'] as num?)?.toDouble(),
      respondComment: json['respondComment'] as String?,
      reimbursementType: json['reimbursementType'] as String?,
      claimType: json['claimType'] as String?,
      taxiCharges: json['taxiCharges'] as String?,
      travellingAmount: json['travellingAmount'] as String?,
      nightStayArrangement: json['nightStayArrangement'] as String?,
      diningAmount: json['diningAmount'] as String?,
      comments: json['comments'] as String,
      body: json['body'] as String,
      isOD: json['isOD'] as bool,
      isFYI: json['isFYI'] as bool,
      isQuestion: json['isQuestion'] as bool,
      isAnswer: json['isAnswer'] as bool,
      isActionable: json['isActionable'] as bool,
      isActionPerformed: json['isActionPerformed'] as bool,
      itemKey: json['itemKey'] as String,
      userComments: json['userComments'] as String?,
      notificationComments: (json['notificationComments'] as List<dynamic>)
          .map((e) => NotificationComments.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PushNotificationToJson(PushNotification instance) =>
    <String, dynamic>{
      'oid': instance.oid,
      'type': instance.type,
      'employeeNumber': instance.employeeNumber,
      'senderName': instance.senderName,
      'oidType': instance.oidType,
      'typeName': instance.typeName,
      'status': instance.status,
      'dateStart': const DateTimeEpochConverter().toJson(instance.dateStart),
      'dateEnd': const DateTimeEpochConverter().toJson(instance.dateEnd),
      'notificationDate':
          const DateTimeEpochConverter().toJson(instance.notificationDate),
      'timeStart': instance.timeStart,
      'timeEnd': instance.timeEnd,
      'toCity': instance.toCity,
      'fromCity': instance.fromCity,
      'absenceDays': instance.absenceDays,
      'absenceHours': instance.absenceHours,
      'comments': instance.comments,
      'reimbursementType': instance.reimbursementType,
      'claimType': instance.claimType,
      'taxiCharges': instance.taxiCharges,
      'travellingAmount': instance.travellingAmount,
      'nightStayArrangement': instance.nightStayArrangement,
      'diningAmount': instance.diningAmount,
      'respondComment': instance.respondComment,
      'body': instance.body,
      'isOD': instance.isOD,
      'isQuestion': instance.isQuestion,
      'isAnswer': instance.isAnswer,
      'isFYI': instance.isFYI,
      'isActionable': instance.isActionable,
      'isActionPerformed': instance.isActionPerformed,
      'itemKey': instance.itemKey,
      'userComments': instance.userComments,
      'notificationComments': instance.notificationComments,
    };
