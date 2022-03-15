import 'package:equatable/equatable.dart';

class TimeLogEvent extends Equatable {
  List<Object> get props => [];
}

class FetchTimeLogEvent extends TimeLogEvent {
  final DateTime? date;
  final DateTime? toDate;
  FetchTimeLogEvent(this.date, this.toDate);
}

class CreateLeaveRequest extends TimeLogEvent {
  final Map<String, dynamic> requestBody;
  
  CreateLeaveRequest(this.requestBody);
}
