import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/outdoor_duty.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/api_util.dart';

class OutDoorApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;

  OutDoorApiClient(this.apiBaseHelper, this.box);

  User? loggedInUser() => box.get('user');

  Future<List<OutDoorDuty>> findAllOutDoor(String employeeNumber, int pageNumber, bool isODInclude, DateTime? startDate) async {
    List<OutDoorDuty> _absence;
    var _user = loggedInUser();

    var response = await apiBaseHelper.post(
      url: '${ApiUtil.absenceEndPoint}',
      body: {
        "isODInclude": isODInclude,
        "startDate": startDate != null ? startDate.millisecondsSinceEpoch : null,
      },
      headers: ApiUtil.headers(
        employeeNumber: employeeNumber,
        pageNumber: '$pageNumber',
        tokenId: _user!.tokenId,
      ),
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }

    var list = response.response!['absenceList'] as List;
    _absence = list.map((e) => OutDoorDuty.fromJson(e)).toList();

    return _absence;
  }

  Future<String> createOutDoor(Map<String, dynamic> requestBody) async {
    var _user = loggedInUser();
    var response = await apiBaseHelper.post(
        url: '${ApiUtil.createLeaveEndPoint}',
        body: requestBody,
        headers: ApiUtil.headers(
          employeeNumber: _user!.employeeNumber,
          tokenId: _user.tokenId,
        ));

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }

    return response.errorMessage;
  }
}
