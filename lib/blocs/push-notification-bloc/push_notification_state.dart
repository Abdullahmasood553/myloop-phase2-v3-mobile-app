import 'package:equatable/equatable.dart';
import 'package:loop_hr/models/push_notification.dart';

abstract class PushNotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class PushNotificationInitial extends PushNotificationState {}

class PushNotificationLoading extends PushNotificationState {}

class PushNotificationLoaded extends PushNotificationState {
  final List<PushNotification> notifications;
  PushNotificationLoaded(this.notifications);

  bool get isLastPage => notifications.isEmpty;

  List<Object> get props => [notifications];

  @override
  String toString() {
    return 'Push Notification Loaded ${notifications.length}';
  }
}


class PushNotificationError extends PushNotificationState {
  final String message;
  PushNotificationError(this.message);

  List<Object> get props => [message];
}




