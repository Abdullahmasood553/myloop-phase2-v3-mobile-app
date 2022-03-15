import 'package:json_annotation/json_annotation.dart';
part 'otp_response.g.dart';

@JsonSerializable()
class OtpResponse {
  final String otp;
  final String employeeCode;
  final String tokenId;

  OtpResponse({required this.otp, required this.employeeCode, required this.tokenId});

  factory OtpResponse.fromJson(Map<String, dynamic> json) => _$OtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpResponseToJson(this);
}
