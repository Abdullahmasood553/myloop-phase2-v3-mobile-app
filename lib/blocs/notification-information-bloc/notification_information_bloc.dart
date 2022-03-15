import 'package:bloc/bloc.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information_event.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information_state.dart';

import '../../repositories/push_notification_repository.dart';

class NotificationInformationBloc extends Bloc<NotificationInformationEvent, NotificationInformationState> {
  final PushNotificationRepository repository;

  NotificationInformationBloc(this.repository) : super(NotificationInformationInitial()) {
    on<NotificationInformationEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(NotificationInformationEvent event, Emitter<NotificationInformationState> emit) async {
    
    if (event is DismissNotification) {
      try {
        emit(NotificationInformationLoading());
        await repository.dismissPushNotification(event.oidNotification);
        emit(NotificationInformationSuccess('Notification status updated successfully'));
      } catch (e) {
        emit(NotificationInformationError(e.toString()));
      }
    }
    
    if (event is CreateApproveRejectNotification) {
      try {
        emit(NotificationInformationLoading());
        await repository.approveOrRejectNotification(event.requestBody);
        emit(NotificationInformationSuccess('Notification status updated successfully'));
      } catch (e) {
        emit(NotificationInformationError(e.toString()));
      }
    }

    if (event is CreateInformationRequest) {
      try {
        emit(NotificationInformationLoading());
        await repository.createInformationRequest(event.requestBody, event.itemKey);
        emit(NotificationInformationSuccess('Information request submitted successfully'));
      } catch (e) {
        emit(NotificationInformationError(e.toString()));
      }
    }
  }
}
