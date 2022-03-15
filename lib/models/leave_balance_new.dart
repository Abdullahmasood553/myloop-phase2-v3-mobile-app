import 'package:json_annotation/json_annotation.dart';
part 'leave_balance_new.g.dart';

@JsonSerializable()
class LeaveBalanceNew {
  final double personalEntitle;
  final double personalConsumed;
  final double personalCpl;
  final double personalBalance;
  final double annualEntitle;
  final double annualConsumed;
  final double annualBalance;

  LeaveBalanceNew({
    required this.personalEntitle,
    required this.personalConsumed,
    required this.personalCpl,
    required this.personalBalance,
    required this.annualEntitle,
    required this.annualConsumed,
    required this.annualBalance,
  });

  factory LeaveBalanceNew.fromJson(Map<String, dynamic> json) => _$LeaveBalanceNewFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveBalanceNewToJson(this);
}
