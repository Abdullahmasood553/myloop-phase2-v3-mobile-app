import 'package:equatable/equatable.dart';
import 'package:loop_hr/models/leave_balance.dart';

abstract class LeaveBalanceState extends Equatable {
  @override
  List<Object> get props => [];
}

class LeaveBalanceInitial extends LeaveBalanceState {}

class LeaveBalanceLoading extends LeaveBalanceState {}

class LeaveBalanceLoaded extends LeaveBalanceState {
  final LeaveBalance data;
  LeaveBalanceLoaded(this.data);

  List<Object> get props => [];
}

class LeaveBalanceError extends LeaveBalanceState {
  final String message;
  LeaveBalanceError(this.message);

  List<Object> get props => [message];
}
