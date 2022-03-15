import 'package:loop_hr/clients/api_clients/attendance_type_api_client.dart';
import 'package:loop_hr/models/attendance_type.dart';

class AttendanceTypeRepository {
  final AttendanceTypeApiClient apiClient;
  AttendanceTypeRepository(this.apiClient);

  Future<List<AttendanceType>> findAllAttendanceType() async {
    return apiClient.findAllAttendanceType();
  }
}
