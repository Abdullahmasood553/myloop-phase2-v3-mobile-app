import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/leave_balance.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/utils.dart';

class LeaveBalanceApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;

  LeaveBalanceApiClient(this.apiBaseHelper, this.box);

  User? loggedInUser() => box.get('user');

  Future<LeaveBalance> findLeaveBalance(String employeeNumber) async {
    var _user = loggedInUser();
    var response = await apiBaseHelper.get(
        url: '${ApiUtil.leaveBalanceEndPoint}',
        headers: ApiUtil.headers(
          tokenId: _user!.tokenId,
          employeeNumber: _user.employeeNumber,
        ));
    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    LeaveBalance _leaveBalance = LeaveBalance.fromJson(response.response!);
    return _leaveBalance;
  }
}
