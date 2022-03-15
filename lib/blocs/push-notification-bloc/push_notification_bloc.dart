import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/push-notification-bloc/push_notification.dart';
import 'package:loop_hr/models/push_notification.dart';
import 'package:loop_hr/repositories/login_repository.dart';
import 'package:loop_hr/repositories/repositories.dart';

class PushNotificationBloc extends Bloc<PushNotificationEvent, PushNotificationState> {
  final PushNotificationRepository repository;
  final LoginRepository loginRepository;

  PushNotificationBloc(this.loginRepository, this.repository) : super(PushNotificationInitial()) {
    on<PushNotificationEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(PushNotificationEvent event, Emitter<PushNotificationState> emit) async {
    if (event is FetchPushNotification) {
      emit(PushNotificationLoading());
      try {
        List<PushNotification> notification = await repository.findAllPushNotification(event.pageNumber);
        emit(PushNotificationLoaded(notification));
      } catch (e) {
        emit(PushNotificationError(e.toString()));
      }
    }
  }
}
