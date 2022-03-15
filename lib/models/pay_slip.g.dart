// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_slip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaySlip _$PaySlipFromJson(Map<String, dynamic> json) => PaySlip(
      oid: json['oid'] as int,
      employeeNumber: json['employeeNumber'] as String,
      payDate: const DateTimeEpochConverter().fromJson(json['payDate'] as int),
      payable: (json['payable'] as num).toDouble(),
      lineItems: (json['lineItems'] as List<dynamic>)
          .map((e) => PaySlipDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaySlipToJson(PaySlip instance) => <String, dynamic>{
      'oid': instance.oid,
      'employeeNumber': instance.employeeNumber,
      'payDate': const DateTimeEpochConverter().toJson(instance.payDate),
      'payable': instance.payable,
      'lineItems': instance.lineItems,
    };

PaySlipDetail _$PaySlipDetailFromJson(Map<String, dynamic> json) =>
    PaySlipDetail(
      elementName: json['elementName'] as String,
      oidPaySlip: json['oidPaySlip'] as int,
      classificationId: json['classificationId'] as int,
      classificationName: json['classificationName'] as String,
      resultValue: json['resultValue'] as String,
    );

Map<String, dynamic> _$PaySlipDetailToJson(PaySlipDetail instance) =>
    <String, dynamic>{
      'elementName': instance.elementName,
      'oidPaySlip': instance.oidPaySlip,
      'classificationId': instance.classificationId,
      'classificationName': instance.classificationName,
      'resultValue': instance.resultValue,
    };
