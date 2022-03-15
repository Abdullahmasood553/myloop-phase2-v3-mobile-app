import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/models/otp_response.dart';
import 'package:loop_hr/utils/utils.dart';

import 'api_exception.dart';

class LoginApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;

  LoginApiClient(this.apiBaseHelper, this.box);

  Future<User> createLogin(Map<String, dynamic> requestBody) async {
    var response = await apiBaseHelper.post(url: '${ApiUtil.loginEndPoint}', body: requestBody);
    if (response.errorCode != 200) {
      throw new ServerError(response.errorMessage);
    }
    User _user = User.fromJson(response.response!);
    box.put('user', _user);
    return _user;
  }

  Future<User> refreshUser() async {
    Map<String, dynamic> _requestBody = {
      'tokenId': loggedInUser()!.tokenId,
      'employeeCode': loggedInUser()!.employeeNumber,
    };

    var response = await apiBaseHelper.post(url: '${ApiUtil.loginEndPoint}', body: _requestBody);
    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    User _user = User.fromJson(response.response!);
    box.put('user', _user);
    return _user;
  }

  User? loggedInUser() => box.get('user');

  Future<void> logoutUser() async {
    await logoutSessionUser();
    box.clear();
    return;
  }

  // OTP Code
  Future<OtpResponse> createOTP(Map<String, dynamic> requestBody) async {
    var response = await apiBaseHelper.post(url: '${ApiUtil.otpGenerateEndPoint}', body: requestBody);

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }

    OtpResponse _data = OtpResponse.fromJson(response.response!);
    print(_data);
    return _data;
  }

  // Logout
  Future<String> logoutSessionUser() async {
    var _user = loggedInUser();
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    var response = await apiBaseHelper.post(
      url: '${ApiUtil.logoutEndPoint}',
      body: {
        "employeeCode": _user!.employeeNumber,
        "tokenId": _user.tokenId,
        "deviceToken": deviceToken,
      },
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    return response.response.toString();
  }

  Future<void> registerDevice(Map<String, dynamic> requestBody) async {
    var _user = loggedInUser();
    var response = await apiBaseHelper.post(
      url: '${ApiUtil.registerDeviceEndPoint}',
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        tokenId: _user.tokenId,
      ),
      body: requestBody,
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    return;
  }
}
