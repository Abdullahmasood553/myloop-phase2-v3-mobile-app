import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/attendance.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/utils.dart';

import 'api_exception.dart';

class TimeLogApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;

  TimeLogApiClient(this.apiBaseHelper, this.box);

  User? loggedInUser() => box.get('user');

  Future<String> createLeaveRequest(Map<String, dynamic> requestBody) async {
    var _user = loggedInUser();
    var response = await apiBaseHelper.post(
      url: '${ApiUtil.createLeaveEndPoint}',
      body: requestBody,
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        tokenId: _user.tokenId,
      ),
    );

    if (response.errorCode != 200) {
      throw new InvalidInputException(response.errorMessage);
    }

    return response.errorMessage;
  }

  Future<List<Attendance>> findAllAttendance(DateTime? toDate, DateTime? date) async {
    List<Attendance>? _attendance;

    var _user = loggedInUser();
    var response = await apiBaseHelper.post(
      url: '${ApiUtil.attendanceEndPoint}',
      body: {
        'date': date != null ? date.millisecondsSinceEpoch : null,
        'endDate': toDate != null ? toDate.millisecondsSinceEpoch : null,
      },
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        tokenId: _user.tokenId,
      ),
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }

    var list = response.response!['attendanceList'] as List;
    _attendance = list.map((e) => Attendance.fromJson(e)).toList();
    return _attendance;
  }
}
