import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:loop_hr/clients/api_clients/api_exception.dart';
import 'package:loop_hr/models/api_response.dart';
import 'package:loop_hr/utils/utils.dart';

class ApiBaseHelper {
  final http.Client httpClient;

  ApiBaseHelper(this.httpClient);

  Future<ApiResponse> get({required String url, Map<String, String>? headers}) async {
    ApiResponse responseJson;
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: headers ?? ApiUtil.headers(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<ApiResponse> post({required String url, Map<String, String>? headers, dynamic body}) async {
    ApiResponse responseJson;
    try {
      final response = await httpClient.post(
        Uri.parse(url),
        headers: headers ?? ApiUtil.headers(),
        body: body != null ? jsonEncode(body) : null,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return ApiResponse.fromJson(jsonDecode(response.body));
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('The application has encountered an unknown error. Please try again later.');
    }
  }
}
