import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:loop_hr/models/date_time_epoch_converter.dart';
import 'package:loop_hr/utils/date_util.dart';

part 'pay_slip.g.dart';

@JsonSerializable()
@DateTimeEpochConverter()
class PaySlip {
  final int oid;
  final String employeeNumber;
  final DateTime payDate;
  final double payable;
  List<PaySlipDetail> lineItems;

  final DateFormat _formatterMonthName = DateFormat('MMM');

  String formattedPayDate() => DateUtil.defaultDateFormat.format(payDate);
  String formattedMonth() => _formatterMonthName.format(payDate);

  PaySlip({
    required this.oid,
    required this.employeeNumber,
    required this.payDate,
    required this.payable,
    required this.lineItems,
  });

  factory PaySlip.fromJson(Map<String, dynamic> json) => _$PaySlipFromJson(json);

  Map<String, dynamic> toJson() => _$PaySlipToJson(this);
}

@JsonSerializable()
class PaySlipDetail {
  final String elementName;
  final int oidPaySlip;
  final int classificationId;
  final String classificationName;
  final String resultValue;

  PaySlipDetail({
    required this.elementName,
    required this.oidPaySlip,
    required this.classificationId,
    required this.classificationName,
    required this.resultValue,
  });
  factory PaySlipDetail.fromJson(Map<String, dynamic> json) => _$PaySlipDetailFromJson(json);

  double get value => double.parse(resultValue);

  Map<String, dynamic> toJson() => _$PaySlipDetailToJson(this);
}
