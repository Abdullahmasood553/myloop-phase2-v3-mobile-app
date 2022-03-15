abstract class NotificationCounterEvent {}

class FetchNotificationCounter extends NotificationCounterEvent {
  final bool forceRefresh;

  FetchNotificationCounter({this.forceRefresh = false});
}
