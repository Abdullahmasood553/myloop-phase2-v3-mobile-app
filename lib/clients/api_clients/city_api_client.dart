import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/city.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/api_util.dart';

class CityApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;
  CityApiClient(this.apiBaseHelper, this.box);
  User? loggedInUser() => box.get('user');

  Future<List<City>> findAllCity() async {
    List<City> _city;
    var _user = loggedInUser();
    var response = await apiBaseHelper.get(
      url: '${ApiUtil.citiesEndPoint}',
      headers: ApiUtil.headers(
        tokenId: _user!.tokenId,
        employeeNumber: _user.employeeNumber,
      ),
    );
    var list = response.response!['citiesList'] as List;
    _city = list.map((e) => City.fromJson(e)).toList();
    return _city;
  }
}
