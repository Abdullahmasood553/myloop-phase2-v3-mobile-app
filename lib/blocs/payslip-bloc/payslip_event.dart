import 'package:equatable/equatable.dart';

abstract class PayslipEvent extends Equatable {
  @override
   List<Object> get props => [];
    // List<PaySlip> get props => [];
}

class FetchPayslip extends PayslipEvent {

}
