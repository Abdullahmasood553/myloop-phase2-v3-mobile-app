import 'package:equatable/equatable.dart';
import 'package:loop_hr/models/pay_slip.dart';

abstract class PayslipState extends Equatable {
  @override
  List<Object> get props => [];
}

class PayslipInitial extends PayslipState {}

class PaySlipLoading extends PayslipState {}

class PaySlipLoaded extends PayslipState {
  final List<PaySlip> slips;

  PaySlipLoaded(this.slips);

  List<Object> get props => [slips];
}

class PaySlipError extends PayslipState {
  final String message;
  PaySlipError(this.message);

  List<Object> get props => [message];
}
