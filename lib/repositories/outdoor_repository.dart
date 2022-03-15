import 'dart:convert';

import 'package:loop_hr/clients/api_clients/outdoor_api_client.dart';
import 'package:loop_hr/models/outdoor_duty.dart';

class OutDoorRepository {
  final OutDoorApiClient apiClient;

  OutDoorRepository(this.apiClient);

  Future<List<OutDoorDuty>> findAllOutDoor(String employeeNumber, int pageNumber, bool isODInclude, DateTime? startDate) {
    return apiClient.findAllOutDoor(employeeNumber, pageNumber, isODInclude, startDate);
  }

  Future<String> createOutDoor(Map<String, dynamic> requestBody) {
      print("OutDoor Json"+JsonEncoder().convert(requestBody));
    return apiClient.createOutDoor(requestBody);
  }
}
