import 'package:json_annotation/json_annotation.dart';
import 'package:loop_hr/models/date_time_epoch_converter.dart';
import 'package:loop_hr/utils/date_util.dart';

part 'attendance.g.dart';

@JsonSerializable()
@DateTimeEpochConverter()
class Attendance {
  final DateTime date;
  List<AttendanceDetail> attendanceDetailList;

  String formattedDate() => DateUtil.defaultDateFormat.format(date);

  Attendance({
    required this.date,
    required this.attendanceDetailList,
  });

  int get attendanceSize => attendanceDetailList.length;

  List<AttendanceDetail> getAttendanceDetailList() {
    attendanceDetailList.sort((a, b) => a.serialNo!.compareTo(b.serialNo!));
    return attendanceDetailList;
  }

  List<AttendanceDetail> _getAllCheckin() {
    return getAttendanceDetailList().where((e) => e.status == 'IN').toList();
  }

  List<AttendanceDetail> _getAllCheckout() {
    return getAttendanceDetailList().where((e) => e.status == 'OUT').toList();
  }

  List<AttendanceDetail> _getAllHolidays() {
    return getAttendanceDetailList().where((e) => e.reason != null).toList();
  }

  List<AttendanceDetailBean> getAttendanceDetailBeanList() {
    List<AttendanceDetailBean> list = List.empty(growable: true);
    for (int i = 0; i < _getAllCheckin().length; i++) {
      var checkIn = _getAllCheckin()[i];
      AttendanceDetailBean bean = new AttendanceDetailBean(
          timeIn: checkIn.time!, serialNo: checkIn.serialNo!);
      try {
        var checkOut = _getAllCheckout()[i];
        bean.setTimeOut(checkOut.time!);
      } catch (e) {
        print('Not Checkout');
      }
      list.add(bean);
    }
    for (AttendanceDetail holiday in _getAllHolidays()) {
      list.add(AttendanceDetailBean.holiday(
          holiday: holiday.reason, serialNo: holiday.serialNo));
    }
    list.sort((a, b) => a.serialNo!.compareTo(b.serialNo!));
    return list;
  }

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceToJson(this);

  @override
  String toString() {
    return date.toString();
  }
}

class AttendanceDetailBean {
  final int? serialNo;
  String? timeIn;
  String? timeOut;
  String? holiday;

  void setTimeOut(String timeOut) {
    this.timeOut = timeOut;
  }

  AttendanceDetailBean(
      {required this.timeIn, this.timeOut, required this.serialNo});

  AttendanceDetailBean.holiday({required this.holiday, required this.serialNo});

  String? getWorkingHours() {
    try {
      if (timeIn != null && timeOut != null) {
        var t1 = double.parse(timeIn!.replaceAll(':', '.'));
        var t2 = double.parse(timeOut!.replaceAll(':', '.'));

        double workingHours = t2 - t1;
        return 'Total\n${workingHours.toStringAsFixed(2)}';
      }
    } catch (e) {}
    return null;
  }

  bool get getIsHoliday => holiday != null;
  String get getTimeIn => '$timeIn';
  String? get getTimeOut => timeOut != null ? '$timeOut' : null;
}

@JsonSerializable()
class AttendanceDetail {
  final int? employeeNumber;
  final int? serialNo;

  @JsonKey(
    fromJson: DateUtil.dateTimeFromEpochUsNullable,
    toJson: DateUtil.dateTimeToEpochUsNullable,
  )
  final DateTime? startDate;

  @JsonKey(
    fromJson: DateUtil.dateTimeFromEpochUsNullable,
    toJson: DateUtil.dateTimeToEpochUsNullable,
  )
  final DateTime? endDate;

  @JsonKey(
    fromJson: DateUtil.dateTimeFromEpochUsNullable,
    toJson: DateUtil.dateTimeToEpochUsNullable,
  )
  final DateTime? inOutDate;

  final String? reason;
  final String? status;
  final String? time;
  final String? shift;
  final String? leaveCode;

  AttendanceDetail({
    this.employeeNumber,
    this.serialNo,
    this.startDate,
    this.endDate,
    this.inOutDate,
    this.reason,
    this.status,
    this.time,
    this.shift,
    this.leaveCode,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) =>
      _$AttendanceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceDetailToJson(this);

  String get getDescription =>
      '${reason == null ? status! + ':' : ''} ${reason == null ? time! : reason!}';
}
