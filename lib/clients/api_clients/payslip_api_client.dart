import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/models.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/api_util.dart';

class PayslipApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;

  PayslipApiClient(this.apiBaseHelper, this.box);

  User? loggedInUser() => box.get('user');

  Future<List<PaySlip>> findAllPayslip() async {
    List<PaySlip> _paySlip;
    var _user = loggedInUser();

    var response = await apiBaseHelper.get(
        url: '${ApiUtil.paySlipEndPoint}',
        headers: ApiUtil.headers(
          employeeNumber: _user!.employeeNumber,
          tokenId: _user.tokenId,
        ));

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }

    var list = response.response!['paySlips'] as List;
    _paySlip = list.map((e) => PaySlip.fromJson(e)).toList();
    return _paySlip;
  }
}
