import 'package:json_annotation/json_annotation.dart';
import 'package:loop_hr/models/push_notification.dart';

part 'push_notification_argument.g.dart';

@JsonSerializable()
class PushNotificationArgument {
  PushNotification pushNotification;
  String? previousRoute;

  PushNotificationArgument(this.pushNotification, this.previousRoute);

  factory PushNotificationArgument.fromJson(Map<String, dynamic> json) => _$PushNotificationArgumentFromJson(json);
  Map<String, dynamic> toJson() => _$PushNotificationArgumentToJson(this);
}
