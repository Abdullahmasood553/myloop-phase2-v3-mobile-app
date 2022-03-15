// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) => Attendance(
      date: const DateTimeEpochConverter().fromJson(json['date'] as int),
      attendanceDetailList: (json['attendanceDetailList'] as List<dynamic>)
          .map((e) => AttendanceDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'date': const DateTimeEpochConverter().toJson(instance.date),
      'attendanceDetailList': instance.attendanceDetailList,
    };

AttendanceDetail _$AttendanceDetailFromJson(Map<String, dynamic> json) =>
    AttendanceDetail(
      employeeNumber: json['employeeNumber'] as int?,
      serialNo: json['serialNo'] as int?,
      startDate:
          DateUtil.dateTimeFromEpochUsNullable(json['startDate'] as int?),
      endDate: DateUtil.dateTimeFromEpochUsNullable(json['endDate'] as int?),
      inOutDate:
          DateUtil.dateTimeFromEpochUsNullable(json['inOutDate'] as int?),
      reason: json['reason'] as String?,
      status: json['status'] as String?,
      time: json['time'] as String?,
      shift: json['shift'] as String?,
      leaveCode: json['leaveCode'] as String?,
    );

Map<String, dynamic> _$AttendanceDetailToJson(AttendanceDetail instance) =>
    <String, dynamic>{
      'employeeNumber': instance.employeeNumber,
      'serialNo': instance.serialNo,
      'startDate': DateUtil.dateTimeToEpochUsNullable(instance.startDate),
      'endDate': DateUtil.dateTimeToEpochUsNullable(instance.endDate),
      'inOutDate': DateUtil.dateTimeToEpochUsNullable(instance.inOutDate),
      'reason': instance.reason,
      'status': instance.status,
      'time': instance.time,
      'shift': instance.shift,
      'leaveCode': instance.leaveCode,
    };
