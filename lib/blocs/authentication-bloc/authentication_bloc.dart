import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/repositories/login_repository.dart';

import 'authentication.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginRepository loginRepository;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  AuthenticationBloc(this.loginRepository) : super(AuthenticationUninitialized()) {
    on<AuthenticationEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(AuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    if (event is AppStarted) {
      emit(AuthenticationLoading());
      final User? loggedInUser = loginRepository.getLoggedInUser;

      if (loggedInUser != null) {
        _registerDevice(loggedInUser);
        await Future.delayed(Duration(milliseconds: 3000));
        emit(AuthenticationAuthenticated(user: loggedInUser));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    }

    if (event is LoggedInUser) {
      emit(AuthenticationLoading());
      final User? loggedInUser = loginRepository.getLoggedInUser;
      if (loggedInUser != null) {
        await _registerDevice(loggedInUser);
      }
      emit(AuthenticationAuthenticated(user: loggedInUser!));
    }

    if (event is LoggedOut) {
      emit(AuthenticationLoading());
      await loginRepository.logoutUser();
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _registerDevice(User loggedInUser) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        Map<String, dynamic> deviceData = <String, dynamic>{};
        deviceData = await getDeviceInfo();
        deviceData['deviceToken'] = token;
        print('Device Token ' +deviceData['deviceToken']);
        deviceData['ownerId'] = loggedInUser.employeeNumber;
        loginRepository.registerDevice(deviceData);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    Map<String, dynamic> _map = {};
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      _map['systemName'] = 'Android';
      _map['brand'] = androidDeviceInfo.model;
    } else {
      var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      _map['systemName'] = iosDeviceInfo.systemName;
      _map['brand'] = iosDeviceInfo.localizedModel;
    }
    return _map;
  }
}
