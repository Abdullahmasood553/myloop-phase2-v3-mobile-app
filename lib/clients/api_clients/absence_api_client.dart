import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/absence.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/api_util.dart';

class AbsenceApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;

  AbsenceApiClient(this.apiBaseHelper, this.box);

  User? loggedInUser() => box.get('user');

  Future<List<Absence>> findAllAbsence(int pageNumber, bool isODInclude, DateTime? startDate, int status) async {
    List<Absence> _absence;
    var _user = loggedInUser();

    var response = await apiBaseHelper.post(
      url: '${ApiUtil.absenceEndPoint}',
      body: {"isODInclude": isODInclude, "startDate": startDate != null ? startDate.millisecondsSinceEpoch : null, "status": status},
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        pageNumber: '$pageNumber',
        tokenId: _user.tokenId,
      ),
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }

    var list = response.response!['absenceList'] as List;
    _absence = list.map((e) => Absence.fromJson(e)).toList();

    return _absence;
  }

  Future<String> cancelLeaveRequest(int absenceAttendanceId) async {
    var _user = loggedInUser();
    var _url = '${ApiUtil.cancelLeaveRequestEndPoint}?absenceAttendanceId=$absenceAttendanceId';
    var response = await apiBaseHelper.get(
      url: _url,
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        tokenId: _user.tokenId,
      ),
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    return response.errorMessage;
  }
}
