import 'package:loop_hr/clients/api_clients/api_clients.dart';
import 'package:loop_hr/models/pay_slip.dart';

class PayslipRepository {
  final PayslipApiClient apiClient;

  PayslipRepository(this.apiClient);

  Future<List<PaySlip>> findAllPayslip() {
    return apiClient.findAllPayslip();
  }
}
