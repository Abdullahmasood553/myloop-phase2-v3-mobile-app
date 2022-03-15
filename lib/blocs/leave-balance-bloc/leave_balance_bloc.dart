import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/leave-balance-bloc/leave_balance.dart';
import 'package:loop_hr/models/leave_balance.dart';
import 'package:loop_hr/repositories/leave_balance_repository.dart';
import 'package:loop_hr/repositories/login_repository.dart';

class LeaveBalanceBloc extends Bloc<LeaveBalanceEvent, LeaveBalanceState> {
  final LeaveBalanceRepository repository;
  final LoginRepository loginRepository;
  LeaveBalanceBloc(this.repository, this.loginRepository) : super(LeaveBalanceInitial()) {
    on<LeaveBalanceEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(LeaveBalanceEvent event, Emitter<LeaveBalanceState> emit) async {
    if (event is LeaveBalanceFetch) {
      emit(LeaveBalanceLoading());
      try {
        LeaveBalance leaveBalance = await repository.findLeaveBalance(loginRepository.getLoggedInUser!.employeeNumber);
        emit(LeaveBalanceLoaded(leaveBalance));
      } catch (e) {
        emit(LeaveBalanceError(e.toString()));
      }
    }
  }
}
