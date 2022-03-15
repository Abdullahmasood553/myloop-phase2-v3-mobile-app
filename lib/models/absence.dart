import 'package:json_annotation/json_annotation.dart';
import 'package:loop_hr/models/date_time_epoch_converter.dart';
import 'package:loop_hr/utils/date_util.dart';

part 'absence.g.dart';

@JsonSerializable()
@DateTimeEpochConverter()
class Absence {
  final String employeeNumber;
  final int? absenceAttendanceId;
  final String absenceType;
  final int? absenceAttendanceTypeId;

  @JsonKey(
    fromJson: DateUtil.dateTimeFromEpochUsNullable,
    toJson: DateUtil.dateTimeToEpochUsNullable,
  )
  final DateTime? startDate;

  String formattedStartDate() => DateUtil.defaultDateFormat.format(startDate!);

  String formattedEndDate() => DateUtil.defaultDateFormat.format(endDate!);

  @JsonKey(
    fromJson: DateUtil.dateTimeFromEpochUsNullable,
    toJson: DateUtil.dateTimeToEpochUsNullable,
  )
  final DateTime? endDate;

  final String? timeStart;
  final String? timeEnd;
  final double? absenceHours;
  final double? absenceDays;
  final String? comments;
  final String? status;

  String? get getStatus => status == 'Pending for Approval' ? 'Pending' : status;

  bool get isCancelable => getStatus == 'Pending';

  Absence({
    required this.employeeNumber,
    this.absenceAttendanceId,
    required this.absenceType,
    this.absenceAttendanceTypeId,
    this.startDate,
    this.endDate,
    this.timeStart,
    this.timeEnd,
    this.absenceHours,
    this.absenceDays,
    this.comments,
    this.status,
  });

  factory Absence.fromJson(Map<String, dynamic> json) => _$AbsenceFromJson(json);
  Map<String, dynamic> toJson() => _$AbsenceToJson(this);
}
