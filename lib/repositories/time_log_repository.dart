import 'package:loop_hr/clients/api_clients/time_log_api_client.dart';
import 'package:loop_hr/models/attendance.dart';

class TimeLogRepository {
  final TimeLogApiClient apiClient;
  TimeLogRepository(this.apiClient);

  Future<List<Attendance>> findAllTimeLog(DateTime? toDate, DateTime? date) {
    return apiClient.findAllAttendance(toDate, date);
  }

  Future<String> createLeaveRequest(Map<String, dynamic> requestBody) {
    return apiClient.createLeaveRequest(requestBody);
  }
}
