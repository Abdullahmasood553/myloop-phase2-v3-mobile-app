import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_event.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_state.dart';
import 'package:loop_hr/models/notification_counter.dart';
import 'package:loop_hr/repositories/push_notification_repository.dart';

class NotificationCounterBloc extends Bloc<NotificationCounterEvent, NotificationCounterLoaded> {
  final PushNotificationRepository repository;

  NotificationCounterBloc(this.repository) : super(NotificationCounterLoaded(false, 0, 0, 0)) {
    on<NotificationCounterEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(NotificationCounterEvent event, Emitter<NotificationCounterLoaded> emit) async {
    if (event is FetchNotificationCounter) {
      NotificationCounter notificationCounter = await repository.notificationCounter();
      emit(NotificationCounterLoaded(event.forceRefresh, notificationCounter.count, notificationCounter.surveyCount, notificationCounter.pollCount));
    }
  }
}
