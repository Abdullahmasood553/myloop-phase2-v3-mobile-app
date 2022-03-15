import 'package:intl/intl.dart';

class DateUtil {
  static DateTime dateTimeFromEpochUs(int us) => DateTime.fromMillisecondsSinceEpoch(us);

  static int dateTimeToEpochUs(DateTime dateTime) => dateTime.millisecondsSinceEpoch;

  static DateTime? dateTimeFromEpochUsNullable(int? us) => us != null ? DateTime.fromMillisecondsSinceEpoch(us) : null;

  static int? dateTimeToEpochUsNullable(DateTime? dateTime) => dateTime != null ? dateTime.millisecondsSinceEpoch : null;

  static DateFormat defaultDateFormat = DateFormat("EEE, MMM d, yyyy");
  static DateFormat defaultTimeFormat = DateFormat("HH:mm");
  static DateFormat defaultDateTimeFormat = DateFormat("EEE MMM d, yyyy HH:mm");
}
