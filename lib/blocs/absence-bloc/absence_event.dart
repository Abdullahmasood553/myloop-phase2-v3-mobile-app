import 'package:equatable/equatable.dart';
import 'package:loop_hr/models/absence.dart';

abstract class AbsenceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAbsenceEvent extends AbsenceEvent {
  final bool isODInclude;
  final int pageNumber;
  final DateTime? startDate;
  final int status;
  FetchAbsenceEvent(this.isODInclude, this.pageNumber, this.startDate, this.status);
}

class CancelLeaveRequestEvent extends AbsenceEvent {
  final Absence absence;
  CancelLeaveRequestEvent(this.absence);
}
