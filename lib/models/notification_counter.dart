import 'package:json_annotation/json_annotation.dart';
part 'notification_counter.g.dart';

@JsonSerializable()
class NotificationCounter {
  final int count;
  final int surveyCount;
  final int pollCount;
  NotificationCounter({
    required this.count,
    required this.surveyCount,
    required this.pollCount
  });


  factory NotificationCounter.fromJson(Map<String, dynamic> json) => _$NotificationCounterFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationCounterToJson(this);
}