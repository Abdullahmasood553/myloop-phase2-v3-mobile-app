import 'package:json_annotation/json_annotation.dart';
import 'package:loop_hr/models/date_time_epoch_converter.dart';
import 'package:loop_hr/models/push_notification_comments.dart';
import 'package:loop_hr/utils/date_util.dart';

part 'push_notification.g.dart';

@JsonSerializable()
@DateTimeEpochConverter()
class PushNotification {
  final int oid;
  final String type;
  final String employeeNumber;
  final String senderName;
  final int oidType;
  final String typeName;
  final String status;
  final DateTime dateStart;
  final DateTime dateEnd;
  final DateTime notificationDate;
  String? timeStart;
  String? timeEnd;
  String? toCity;
  String? fromCity;
  double? absenceDays;
  double? absenceHours;
  final String comments;
  String? reimbursementType;
  String? claimType;
  String? taxiCharges;
  String? travellingAmount;
  String? nightStayArrangement;
  String? diningAmount;
  final String? respondComment;
  final String body;
  final bool isOD;
  final bool isQuestion;
  final bool isAnswer;
  final bool isFYI;
  late final bool isActionable;
  final bool isActionPerformed;
  final String itemKey;
  String? userComments;
  List<NotificationComments> notificationComments;

  String formattedDateStart() => DateUtil.defaultDateFormat.format(dateStart);
  String formattedDateEnd() => DateUtil.defaultDateFormat.format(dateEnd);

  PushNotification({
    required this.oid,
    required this.type,
    required this.employeeNumber,
    required this.senderName,
    required this.oidType,
    required this.typeName,
    required this.status,
    required this.dateStart,
    required this.dateEnd,
    required this.notificationDate,
    this.timeStart,
    this.timeEnd,
    this.fromCity,
    this.toCity,
    this.absenceDays,
    this.absenceHours,
    this.respondComment,
    this.reimbursementType,
    this.claimType,
    this.taxiCharges,
    this.travellingAmount,
    this.nightStayArrangement,
    this.diningAmount,
    required this.comments,
    required this.body,
    required this.isOD,
    required this.isFYI,
    required this.isQuestion,
    required this.isAnswer,
    required this.isActionable,
    required this.isActionPerformed,
    required this.itemKey,
    this.userComments,
    required this.notificationComments
  });

  String? get getReason => respondComment;

  factory PushNotification.fromJson(Map<String, dynamic> json) => _$PushNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);
}

