import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/attendance_type.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/api_util.dart';

class AttendanceTypeApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;

  AttendanceTypeApiClient(this.apiBaseHelper, this.box);

  User? loggedInUser() => box.get('user');

  Future<List<AttendanceType>> findAllAttendanceType() async {
    List<AttendanceType> _attendanceType;
    var _user = loggedInUser();
    var response = await apiBaseHelper.get(
        url: '${ApiUtil.attendanceTypeEndPoint}',
        headers: ApiUtil.headers(
          tokenId: _user!.tokenId,
          employeeNumber: _user.employeeNumber,
        ));
    var list = response.response!['absenceTypes'] as List;
    _attendanceType = list.map((e) => AttendanceType.fromJson(e)).toList();
    // print('Attendance Type: ' + _attendanceType.toString());
    return _attendanceType;
  }
}
