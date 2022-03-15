import 'package:json_annotation/json_annotation.dart';
import 'date_time_epoch_converter.dart';
part 'outdoor_duty.g.dart';

@JsonSerializable()
@DateTimeEpochConverter()
class OutDoorDuty {
  final String employeeNumber;
  final int absenceAttendanceId;
  final String absenceType;
  final int absenceAttendanceTypeId;
  final DateTime startDate;
  final DateTime endDate;
  final String timeStart;
  final String timeEnd;
  final double absenceHours;
  final int? absenceDays;
  final String comments;

  OutDoorDuty({
    required this.employeeNumber,
    required this.absenceAttendanceId,
    required this.absenceType,
    required this.absenceAttendanceTypeId,
    required this.startDate,
    required this.endDate,
    required this.timeStart,
    required this.timeEnd,
    required this.absenceHours,
    this.absenceDays,
    required this.comments,
  });

    factory OutDoorDuty.fromJson(Map<String, dynamic> json) => _$OutDoorDutyFromJson(json);
    Map<String, dynamic> toJson() => _$OutDoorDutyToJson(this);
}
