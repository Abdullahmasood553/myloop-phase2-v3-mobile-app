import 'package:json_annotation/json_annotation.dart';
part 'leave_balance.g.dart';

@JsonSerializable()
class LeaveBalance {
  final double personalEntitle;
  final double personalConsumed;
  final double personalCpl;
  final double personalBalance;
  final double annualEntitle;
  final double annualConsumed;
  final double annualBalance;

  LeaveBalance({
    required this.personalEntitle,
    required this.personalConsumed,
    required this.personalCpl,
    required this.personalBalance,
    required this.annualEntitle,
    required this.annualConsumed,
    required this.annualBalance,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) => _$LeaveBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveBalanceToJson(this);
}
