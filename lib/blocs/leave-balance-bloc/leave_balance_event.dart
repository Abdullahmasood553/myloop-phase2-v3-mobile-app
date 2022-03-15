import 'package:equatable/equatable.dart';
import 'package:loop_hr/models/leave_balance.dart';

class LeaveBalanceEvent extends Equatable {
  List<LeaveBalance> get props => [];
}

class LeaveBalanceFetch extends LeaveBalanceEvent {}
