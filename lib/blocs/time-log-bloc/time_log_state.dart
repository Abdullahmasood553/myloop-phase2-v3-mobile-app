import 'package:equatable/equatable.dart';
import 'package:loop_hr/models/attendance.dart';
import 'package:loop_hr/utils/api_util.dart';

abstract class TimeLogState extends Equatable {
  @override
  List<Object> get props => [];
}

class TimeLogInitial extends TimeLogState {}

class TimeLogLoading extends TimeLogState {}

class TimeLogLoaded extends TimeLogState {
  final List<Attendance> attendanceList;
  TimeLogLoaded(this.attendanceList);

  int totalRecords() {
    int size = 0;
    attendanceList.forEach((e) {
      size += e.attendanceSize;
    });
    return size;
  }

  bool get isLastPage => totalRecords() < ApiUtil.defaultPageSize;

  List<Object> get props => [attendanceList];
}

class TimeLogError extends TimeLogState {
  final String message;
  TimeLogError(this.message);

  List<Object> get props => [message];
}

class LeaveRequestLoading extends TimeLogState {}

class LeaveRequestSuccess extends TimeLogState {
  final String message;
  LeaveRequestSuccess(this.message);
  List<Object> get props => [message];
}

class LeaveRequestError extends TimeLogState {
  final String message;
  LeaveRequestError(this.message);
}
