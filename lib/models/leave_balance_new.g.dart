// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_balance_new.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveBalanceNew _$LeaveBalanceNewFromJson(Map<String, dynamic> json) =>
    LeaveBalanceNew(
      personalEntitle: (json['personalEntitle'] as num).toDouble(),
      personalConsumed: (json['personalConsumed'] as num).toDouble(),
      personalCpl: (json['personalCpl'] as num).toDouble(),
      personalBalance: (json['personalBalance'] as num).toDouble(),
      annualEntitle: (json['annualEntitle'] as num).toDouble(),
      annualConsumed: (json['annualConsumed'] as num).toDouble(),
      annualBalance: (json['annualBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$LeaveBalanceNewToJson(LeaveBalanceNew instance) =>
    <String, dynamic>{
      'personalEntitle': instance.personalEntitle,
      'personalConsumed': instance.personalConsumed,
      'personalCpl': instance.personalCpl,
      'personalBalance': instance.personalBalance,
      'annualEntitle': instance.annualEntitle,
      'annualConsumed': instance.annualConsumed,
      'annualBalance': instance.annualBalance,
    };
