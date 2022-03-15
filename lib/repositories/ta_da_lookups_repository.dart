import 'package:loop_hr/clients/api_clients/ta_ta_lookups_api_client.dart';
import 'package:loop_hr/models/ta_da_lookups.dart';

class TADALookupsRepository {
  final TADALookupsApiClient apiClient;
  TADALookupsRepository(this.apiClient);

  Future<List<TADALookups>> findAllTADALookups() {
    return apiClient.findAllTADA();
  }

}