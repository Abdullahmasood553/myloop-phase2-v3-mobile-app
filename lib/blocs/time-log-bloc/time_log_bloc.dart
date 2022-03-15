import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/time-log-bloc/time_log.dart';
import 'package:loop_hr/repositories/login_repository.dart';
import 'package:loop_hr/repositories/time_log_repository.dart';
import 'package:loop_hr/models/attendance.dart';

class TimeLogBloc extends Bloc<TimeLogEvent, TimeLogState> {
  final TimeLogRepository repository;
  final LoginRepository loginRepository;
  TimeLogBloc(this.repository, this.loginRepository) : super(TimeLogInitial()) {
    on<TimeLogEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(TimeLogEvent event, Emitter<TimeLogState> emit) async {
    if (event is FetchTimeLogEvent) {
      emit(TimeLogLoading());
      try {
        List<Attendance> attendance = await repository.findAllTimeLog(event.toDate, event.date);
        emit(TimeLogLoaded(attendance));
      } catch (e) {
        emit(TimeLogError(e.toString()));
      }
    }

    if (event is CreateLeaveRequest) {
      try {
        emit(LeaveRequestLoading());
        await repository.createLeaveRequest(event.requestBody);
        emit(LeaveRequestSuccess('Leave Request has been submitted for approval'));
      } catch (e) {
        emit(LeaveRequestError(e.toString()));
      }
    }
  }
}
