import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final int errorCode;
  final String errorMessage;
  final Map<String, dynamic>? response;

  ApiResponse(
    this.errorCode,
    this.errorMessage,
    this.response,
  );

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
