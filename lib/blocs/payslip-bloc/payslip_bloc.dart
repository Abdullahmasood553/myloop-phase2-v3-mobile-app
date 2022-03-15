import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/payslip-bloc/payslip.dart';
import 'package:loop_hr/models/pay_slip.dart';
import 'package:loop_hr/repositories/login_repository.dart';
import 'package:loop_hr/repositories/repositories.dart';

class PayslipBloc extends Bloc<PayslipEvent, PayslipState> {
  final PayslipRepository payslipRepository;
  final LoginRepository loginRepository;

  PayslipBloc(this.payslipRepository, this.loginRepository) : super(PayslipInitial()) {
    on<PayslipEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(PayslipEvent event, Emitter<PayslipState> emit) async {
    if (event is FetchPayslip) {
      emit(PaySlipLoading());
      try {
        List<PaySlip> slips = await payslipRepository.findAllPayslip();
        emit(PaySlipLoaded(slips));
      } catch (e) {
        emit(PaySlipError(e.toString()));
      }
    }
  }
}
