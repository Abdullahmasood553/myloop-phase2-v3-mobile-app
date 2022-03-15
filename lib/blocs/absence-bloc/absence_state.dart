import 'package:equatable/equatable.dart';
import 'package:loop_hr/models/absence.dart';

abstract class AbsenceState extends Equatable {
  @override
  List<Object> get props => [];
}

class AbsenceInitial extends AbsenceState {}

class AbsenceLoading extends AbsenceState {}

class AbsenceLoaded extends AbsenceState {
  final List<Absence> absence;

  AbsenceLoaded(this.absence);

  List<Object> get props => [absence];
}

class AbsenceError extends AbsenceState {
  final String message;
  AbsenceError(this.message);

  List<Object> get props => [message];
}

class CancelLeaveRequestLoading extends AbsenceState {}


class CancelLeaveRequestSuccess extends AbsenceState {
  final String message;
  CancelLeaveRequestSuccess(this.message);
  List<Object> get props => [message];
}


class CancelLeaveRequestError extends AbsenceState {
  final String message;
  CancelLeaveRequestError(this.message);
}