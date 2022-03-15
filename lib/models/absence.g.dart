// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Absence _$AbsenceFromJson(Map<String, dynamic> json) => Absence(
      employeeNumber: json['employeeNumber'] as String,
      absenceAttendanceId: json['absenceAttendanceId'] as int?,
      absenceType: json['absenceType'] as String,
      absenceAttendanceTypeId: json['absenceAttendanceTypeId'] as int?,
      startDate:
          DateUtil.dateTimeFromEpochUsNullable(json['startDate'] as int?),
      endDate: DateUtil.dateTimeFromEpochUsNullable(json['endDate'] as int?),
      timeStart: json['timeStart'] as String?,
      timeEnd: json['timeEnd'] as String?,
      absenceHours: (json['absenceHours'] as num?)?.toDouble(),
      absenceDays: (json['absenceDays'] as num?)?.toDouble(),
      comments: json['comments'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AbsenceToJson(Absence instance) => <String, dynamic>{
      'employeeNumber': instance.employeeNumber,
      'absenceAttendanceId': instance.absenceAttendanceId,
      'absenceType': instance.absenceType,
      'absenceAttendanceTypeId': instance.absenceAttendanceTypeId,
      'startDate': DateUtil.dateTimeToEpochUsNullable(instance.startDate),
      'endDate': DateUtil.dateTimeToEpochUsNullable(instance.endDate),
      'timeStart': instance.timeStart,
      'timeEnd': instance.timeEnd,
      'absenceHours': instance.absenceHours,
      'absenceDays': instance.absenceDays,
      'comments': instance.comments,
      'status': instance.status,
    };
