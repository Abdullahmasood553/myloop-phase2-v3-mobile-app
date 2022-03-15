import 'package:json_annotation/json_annotation.dart';

part 'attendance_type.g.dart';

@JsonSerializable()
class AttendanceType {
  int oid;
  String typeName;

  AttendanceType({required this.oid, required this.typeName});
  factory AttendanceType.fromJson(Map<String, dynamic> json) => _$AttendanceTypeFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceTypeToJson(this);
}
