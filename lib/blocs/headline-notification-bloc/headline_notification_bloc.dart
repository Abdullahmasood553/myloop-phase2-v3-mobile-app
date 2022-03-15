import 'package:bloc/bloc.dart';
import 'package:loop_hr/blocs/push-notification-bloc/push_notification.dart';
import 'package:loop_hr/models/models.dart';
import 'package:loop_hr/repositories/push_notification_repository.dart';

class HeadlineNotificationBloc extends Bloc<PushNotificationEvent, PushNotificationState> {
  final PushNotificationRepository repository;

  HeadlineNotificationBloc(this.repository) : super(PushNotificationInitial()) {
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
