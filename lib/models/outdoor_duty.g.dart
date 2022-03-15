// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outdoor_duty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutDoorDuty _$OutDoorDutyFromJson(Map<String, dynamic> json) => OutDoorDuty(
      employeeNumber: json['employeeNumber'] as String,
      absenceAttendanceId: json['absenceAttendanceId'] as int,
      absenceType: json['absenceType'] as String,
      absenceAttendanceTypeId: json['absenceAttendanceTypeId'] as int,
      startDate:
          const DateTimeEpochConverter().fromJson(json['startDate'] as int),
      endDate: const DateTimeEpochConverter().fromJson(json['endDate'] as int),
      timeStart: json['timeStart'] as String,
      timeEnd: json['timeEnd'] as String,
      absenceHours: (json['absenceHours'] as num).toDouble(),
      absenceDays: json['absenceDays'] as int?,
      comments: json['comments'] as String,
    );

Map<String, dynamic> _$OutDoorDutyToJson(OutDoorDuty instance) =>
    <String, dynamic>{
      'employeeNumber': instance.employeeNumber,
      'absenceAttendanceId': instance.absenceAttendanceId,
      'absenceType': instance.absenceType,
      'absenceAttendanceTypeId': instance.absenceAttendanceTypeId,
      'startDate': const DateTimeEpochConverter().toJson(instance.startDate),
      'endDate': const DateTimeEpochConverter().toJson(instance.endDate),
      'timeStart': instance.timeStart,
      'timeEnd': instance.timeEnd,
      'absenceHours': instance.absenceHours,
      'absenceDays': instance.absenceDays,
      'comments': instance.comments,
    };
