import 'package:loop_hr/clients/api_clients/login_api_client.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/models/otp_response.dart';

class LoginRepository {
  final LoginApiClient apiClient;
  LoginRepository(this.apiClient);

  Future<User> createLogin(Map<String, dynamic> requestBody) {
    return apiClient.createLogin(requestBody);
  }

  Future<User> refreshUser() {
    return apiClient.refreshUser();
  }

  Future<OtpResponse> createOTP(Map<String, dynamic> requestBody) {
    return apiClient.createOTP(requestBody);
  }

  User? get getLoggedInUser => apiClient.loggedInUser();

  void registerDevice(Map<String, dynamic> requestBody) {
    apiClient.registerDevice(requestBody);
  }

  Future<void> logoutUser() {
    return apiClient.logoutUser();
  }
}
