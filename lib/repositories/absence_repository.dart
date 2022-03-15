import 'package:loop_hr/clients/api_clients/absence_api_client.dart';
import 'package:loop_hr/models/absence.dart';

class AbsenceRepository {
  final AbsenceApiClient apiClient;

  AbsenceRepository(this.apiClient);

  Future<List<Absence>> findAllAbsence(int pageNumber, bool isODInclude, DateTime? startDate, int event) {
    return apiClient.findAllAbsence(pageNumber, isODInclude, startDate, event);
  }

  // Cancel Leave Request
  Future<String> cancelLeaveRequest(int absenceAttendanceId) {
    return apiClient.cancelLeaveRequest(absenceAttendanceId);
  }
}
