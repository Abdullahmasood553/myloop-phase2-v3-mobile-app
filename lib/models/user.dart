import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:loop_hr/models/date_time_epoch_converter.dart';

part 'user.g.dart';

@JsonSerializable()
@DateTimeEpochConverter()
@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String employeeNumber;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String grade;

  @HiveField(3)
  final String gradeType;

  @HiveField(4)
  final String positionTitle;

  @HiveField(5)
  final String department;

  @HiveField(6)
  final DateTime hireDate;

  @HiveField(7)
  String? email;

  @HiveField(8)
  final String servicePeriod;

  @HiveField(9)
  String? location;

  @HiveField(10)
  String? supervisorName;

  @HiveField(11)
  String? supervisorCode;

  @HiveField(12)
  String? tokenId;

  @HiveField(13)
  final String firstName;

  @JsonKey(defaultValue: 'M')
  @HiveField(14, defaultValue: 'M')
  final String? gender;

  @JsonKey(defaultValue: false)
  @HiveField(15, defaultValue: false)
  final bool reimbursementFlag;

  @JsonKey(defaultValue: false)
  @HiveField(16, defaultValue: false)
  final bool claimFlag;

  @JsonKey(defaultValue: false)
  @HiveField(17, defaultValue: false)
  final bool taxiFlag;

  @JsonKey(defaultValue: false)
  @HiveField(18, defaultValue: false)
  final bool nightStayFlag;

  @JsonKey(defaultValue: false)
  @HiveField(19, defaultValue: false)
  final bool travellingAmountFlag;

  @JsonKey(defaultValue: false)
  @HiveField(20, defaultValue: false)
  final bool diningAmountFlag;


  User({
    required this.employeeNumber,
    required this.fullName,
    required this.grade,
    required this.gradeType,
    required this.positionTitle,
    required this.department,
    required this.hireDate,
    this.email,
    required this.servicePeriod,
    this.location,
    this.supervisorName,
    this.supervisorCode,
    this.tokenId,
    required this.firstName,
    this.gender,
    required this.reimbursementFlag,
    required this.claimFlag,
    required this.taxiFlag,
    required this.nightStayFlag,
    required this.travellingAmountFlag,
    required this.diningAmountFlag
  });





  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
