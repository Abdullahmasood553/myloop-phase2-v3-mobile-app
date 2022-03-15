import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/survey.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/api_util.dart';

class SurveyApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;

  SurveyApiClient(this.apiBaseHelper, this.box);

  User? loggedInUser() => box.get('user');

  Future<String> createSurveyResponseRequest(Map<String, dynamic> requestBody) async {
    var _user = loggedInUser();
    var response = await apiBaseHelper.post(
      url: '${ApiUtil.submitSurveyResponseEndPoint}',
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        tokenId: _user.tokenId,
      ),
      body: requestBody,
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    return response.errorMessage;
  }

  Future<List<Survey>> findAllSurvey() async {
    List<Survey>? _survey;
    var _user = loggedInUser();
    var response = await apiBaseHelper.get(
        url: '${ApiUtil.fetchSurveyEndPoint}',
        headers: ApiUtil.headers(
          employeeNumber: _user!.employeeNumber,
          tokenId: _user.tokenId,
        ));

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }

    var list = response.response!['surveyList'] as List;
    _survey = list.map((e) => Survey.fromJson(e)).toList();
    return _survey;
  }
}
