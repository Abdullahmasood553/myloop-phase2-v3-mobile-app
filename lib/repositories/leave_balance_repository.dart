import 'package:loop_hr/clients/api_clients/leave_balance_api_client.dart';
import 'package:loop_hr/models/leave_balance.dart';

class LeaveBalanceRepository {
  final LeaveBalanceApiClient apiClient;

  LeaveBalanceRepository(this.apiClient);

  Future<LeaveBalance> findLeaveBalance(String employeeNumber) {
    return apiClient.findLeaveBalance(employeeNumber);
  }
}
