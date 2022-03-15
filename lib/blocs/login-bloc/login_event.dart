class LoginEvent {}

class Login extends LoginEvent {
  final Map<String, dynamic> requestBody;
  Login(this.requestBody);
}



// OTP Code
class CreateOTP extends LoginEvent {
  final Map<String, dynamic> requestBody;
  CreateOTP(this.requestBody);
}

