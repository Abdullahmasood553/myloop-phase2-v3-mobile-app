import 'package:loop_hr/clients/api_clients/survey_api_client.dart';
import 'package:loop_hr/models/survey.dart';
import 'package:loop_hr/models/survey_response.dart';

class SurveyRepository {
  final SurveyApiClient apiClient;
  SurveyRepository(this.apiClient);

  Future<List<Survey>> findAllSurvey() {
    return apiClient.findAllSurvey();
  }

  Future<String> createSurveyRequest(Map<String, dynamic> requestBody) {
    return apiClient.createSurveyResponseRequest(requestBody);
  }

}
