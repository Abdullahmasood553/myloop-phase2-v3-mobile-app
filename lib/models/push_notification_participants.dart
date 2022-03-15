import 'package:json_annotation/json_annotation.dart';

part 'push_notification_participants.g.dart';

@JsonSerializable()
class PushNotificationParticipants {
  final String itemKey;
  final String recipientRole;
  final String lastName;
  final String employeeNumber;

  PushNotificationParticipants({
    required this.itemKey,
    required this.recipientRole,
    required this.lastName,
    required this.employeeNumber
  });

  factory PushNotificationParticipants.fromJson(Map<String, dynamic> json) => _$PushNotificationParticipantsFromJson(json);
  Map<String, dynamic> toJson() => _$PushNotificationParticipantsToJson(this);
}


