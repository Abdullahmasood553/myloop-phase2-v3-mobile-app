import 'package:loop_hr/models/otp_response.dart';
import 'package:loop_hr/models/user.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {}

class LoginCreated extends LoginState {
  final String message;
  LoginCreated(this.message);
}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess(this.user);
}

class LoginError extends LoginState {
  final String response;
  LoginError(this.response);
}

// OTP Code
class OTPCreated extends LoginState {
  final String message;
  OTPCreated(this.message);

  @override
  String toString() {
    return 'OTPCreated: $message';
  }
}

class OTPSuccess extends LoginState {
  final OtpResponse otp;
  OTPSuccess(this.otp);

  @override
  String toString() {
    return 'OTPSuccess: ${otp.otp}';
  }
}

class OTPError extends LoginState {
  final String response;
  OTPError(this.response);
}
