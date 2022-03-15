import 'package:equatable/equatable.dart';

abstract class PushNotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPushNotification extends PushNotificationEvent {
  final int pageNumber;
  FetchPushNotification(this.pageNumber);
}

class FetchPushNotificationComments extends PushNotificationEvent {
  final String itemKey;
  FetchPushNotificationComments(this.itemKey);
}



