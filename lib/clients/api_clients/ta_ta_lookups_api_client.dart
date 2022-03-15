import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/ta_da_lookups.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/api_util.dart';
import 'package:loop_hr/utils/utils.dart';

class TADALookupsApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;
  TADALookupsApiClient(this.apiBaseHelper, this.box);
  User? loggedInUser() => box.get('user');
  Future<List<TADALookups>> findAllTADA() async {
    List<TADALookups> _tada;
    var _user = loggedInUser();
    var response = await apiBaseHelper.get(
      url: '${ApiUtil.tadaLookupsEndPoint}',
      headers: ApiUtil.headers(
        tokenId: _user!.tokenId,
        employeeNumber: _user.employeeNumber,
      ),
    );
    var list = response.response!['tadaLookups'] as List;
    _tada = list.map((e) => TADALookups.fromJson(e)).toList();
    return _tada;
  }

}