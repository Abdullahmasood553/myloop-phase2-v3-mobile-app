import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:loop_hr/blocs/absence-bloc/absence_event.dart';
import 'package:loop_hr/blocs/absence-bloc/absence_state.dart';
import 'package:loop_hr/models/absence.dart';
import 'package:loop_hr/repositories/absence_repository.dart';
import 'package:loop_hr/repositories/login_repository.dart';

class AbsenceBloc extends Bloc<AbsenceEvent, AbsenceState> {
  final AbsenceRepository repository;
  final LoginRepository loginRepository;

  AbsenceBloc(this.repository, this.loginRepository) : super(AbsenceInitial()) {
    on<AbsenceEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(
      AbsenceEvent event, Emitter<AbsenceState> emit) async {
    if (event is FetchAbsenceEvent) {
      emit(AbsenceLoading());
      try {
        List<Absence> absence = await repository.findAllAbsence(
            event.pageNumber, event.isODInclude, event.startDate, event.status);
        emit(AbsenceLoaded(absence));
      } catch (e) {
        emit(AbsenceError(e.toString()));
      }
    }

    if (event is CancelLeaveRequestEvent) {
      try {
        emit(CancelLeaveRequestLoading());
        await repository.cancelLeaveRequest(event.absence.absenceAttendanceId!);
        emit(CancelLeaveRequestSuccess('Leave request has been cancelled'));
      } catch (e) {
        emit(CancelLeaveRequestError(e.toString()));
      }
    }
  }
}
