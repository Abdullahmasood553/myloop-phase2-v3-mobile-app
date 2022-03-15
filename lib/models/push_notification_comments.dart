import 'package:json_annotation/json_annotation.dart';
import '../utils/date_util.dart';
import 'date_time_epoch_converter.dart';

part 'push_notification_comments.g.dart';

@JsonSerializable()
@DateTimeEpochConverter()
class NotificationComments {
  final String itemKey;
  final DateTime commentDate;
  final int notificationId;
  final String fromUser;
  final String action;
  String? userComment;

    String formattedCommentDate() => DateUtil.defaultDateFormat.format(commentDate);

  NotificationComments({
    required this.itemKey,
    required this.commentDate,
    required this.notificationId,
    required this.fromUser,
    required this.action,
    this.userComment,
  });

  factory NotificationComments.fromJson(Map<String, dynamic> json) => _$NotificationCommentsFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationCommentsToJson(this);
}
