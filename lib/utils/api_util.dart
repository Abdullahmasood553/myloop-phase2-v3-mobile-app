class ApiUtil {
  static Map<String, String> headers({String? employeeNumber = "", String? pageNumber = "", String? tokenId = "", String? itemKey = ""}) {
    return new Map.from({"Content-Type": "application/json; charset=utf-8", "X-EmployeeCode": employeeNumber, "X-PageNumber": pageNumber, "X-TokenId": tokenId, "X-ItemKey": itemKey});
  }

  static final int defaultPageSize = 30;
  //
  //static final String _baseUrl = 'http://192.168.175.30:8080/v1'; // abdullah systems network
   static final String _baseUrlV2 = 'http://192.168.175.78:8080/v2'; // abdullah systems network

  // static final String _baseUrl =
  //     'http://192.168.175.96:8080/v1'; // ahmed systems network

  // static final String _baseUrl =
  //     'http://192.168.175.105:8080/v1'; // junaid systems network
  // static final String _baseUrlV2 = 'http://192.168.175.105:8080/v2';
   // static final String _baseUrlV2 = 'https://myloop-api.interloop.com.pk/v2'; // junaid systems network

  // static final String _baseUrl = 'https://aws-myloop-api.interloop.com.pk/v1';
  // static final String _baseUrlV2 = 'https://aws-myloop-api.interloop.com.pk/v2';

  static final String _hrBaseUrlV2 = '$_baseUrlV2/hr';

  static final String loginEndPoint = '$_hrBaseUrlV2/login';
  static final String paySlipEndPoint = '$_hrBaseUrlV2/payslip';
  static final String attendanceEndPoint = '$_hrBaseUrlV2/attendance';
  static final String absenceEndPoint = '$_hrBaseUrlV2/absence';
  static final String attendanceTypeEndPoint = '$_hrBaseUrlV2/absence_types';
  static final String profileImageEndPoint = '$_hrBaseUrlV2/profile_image';
  static final String leaveBalanceEndPoint = '$_hrBaseUrlV2/leave_balance';
  static final String otpGenerateEndPoint = '$_hrBaseUrlV2/generate_otp';
  static final String createLeaveEndPoint = '$_hrBaseUrlV2/create_leave';
  static final String pushNotificationEndPoint = '$_hrBaseUrlV2/notification';
  static final String notificationCounterEndPoint = '$_hrBaseUrlV2/open_notification_count';
  static final String approveRejectNotificationEndPoint = '$_hrBaseUrlV2/approve_reject_leave_request';
  static final String dismissNotificationEndPoint = '$_hrBaseUrlV2/dismiss_notification';
  static final String cancelLeaveRequestEndPoint = '$_hrBaseUrlV2/cancel_leave_request';
  static final String citiesEndPoint = '$_hrBaseUrlV2/cities';
  static final String logoutEndPoint = '$_hrBaseUrlV2/logout';
  static final String registerDeviceEndPoint = '$_hrBaseUrlV2/register_device';

  static final String fetchSurveyEndPoint = '$_hrBaseUrlV2/fetch_survey';
  static final String submitSurveyResponseEndPoint = '$_hrBaseUrlV2/submit_survey_response';

  static final String tadaLookupsEndPoint = '$_hrBaseUrlV2/ta_da_lookups';
  static final String notificationParticipantsEndPoint = '$_hrBaseUrlV2/notification_participants';
  static final String notificationCommentsEndPoint = '$_hrBaseUrlV2/notification_comments';
  static final String moreInformationRequestEndPoint = '$_hrBaseUrlV2/more_info_request';
  
  
}
