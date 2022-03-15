import 'package:loop_hr/clients/api_clients/city_api_client.dart';
import 'package:loop_hr/models/city.dart';

class CityRepository {
  final CityApiClient apiClient;
  CityRepository(this.apiClient);

  Future<List<City>> findAllCity() {
    return apiClient.findAllCity();
  }
}
