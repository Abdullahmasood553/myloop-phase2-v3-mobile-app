import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/login-bloc/login.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/models/otp_response.dart';
import 'package:loop_hr/repositories/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is Login) {
      try {
        User user = await repository.createLogin(event.requestBody);
        emit(LoginSuccess(user));
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    }
    if (event is CreateOTP) {
      try {
        OtpResponse otp = await repository.createOTP(event.requestBody);
        emit(OTPSuccess(otp));
      } catch (e) { 
        emit(OTPError(e.toString()));
      }
    }
  }
}
