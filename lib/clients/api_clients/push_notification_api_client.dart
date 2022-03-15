import 'package:hive/hive.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/models/models.dart';
import 'package:loop_hr/models/notification_counter.dart';
import 'package:loop_hr/models/push_notification_participants.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/utils/api_util.dart';

import '../../models/push_notification_comments.dart';

class PushNotificationApiClient {
  final ApiBaseHelper apiBaseHelper;
  final Box<User> box;
  PushNotificationApiClient(this.apiBaseHelper, this.box);

  User? loggedInUser() => box.get('user');

  Future<List<PushNotification>> findAllPushNotification(int pageNumber) async {
    List<PushNotification> _pushNotifications;
    var _user = loggedInUser();
    var response = await apiBaseHelper.get(
      url: '${ApiUtil.pushNotificationEndPoint}',
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        pageNumber: '$pageNumber',
        tokenId: _user.tokenId,
      ),
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }

    var list = response.response!['notifications'] as List;
    _pushNotifications = list.map((e) => PushNotification.fromJson(e)).toList();
    return _pushNotifications;
  }

  // Approve or Reject
  Future<String> approveOrRejectNotification(Map<String, dynamic> requestBody) async {
    var _user = loggedInUser();
    var response = await apiBaseHelper.post(
        url: '${ApiUtil.approveRejectNotificationEndPoint}',
        body: requestBody,
        headers: ApiUtil.headers(
          employeeNumber: _user!.employeeNumber,
          tokenId: _user.tokenId,
        ));

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    return response.errorMessage;
  }

  Future<String> dismissPushNotification(int oidNotification) async {
    var _user = loggedInUser();
    var _url = '${ApiUtil.dismissNotificationEndPoint}?oidNotification=$oidNotification';
    var response = await apiBaseHelper.get(
      url: _url,
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        tokenId: _user.tokenId,
      ),
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    return response.errorMessage;
  }

  // Future<int> notificationCounter() async {
  //   var _user = loggedInUser();
  //   var response = await apiBaseHelper.get(
  //       url: '${ApiUtil.notificationCounterEndPoint}',
  //       headers: ApiUtil.headers(
  //         employeeNumber: _user!.employeeNumber,
  //         tokenId: _user.tokenId,
  //       ));
  //   if (response.errorCode != 200) {
  //     throw new Exception(response.errorMessage);
  //   }
  //   return response.response!['count'];
  //
  // }

  Future<NotificationCounter> notificationCounter() async {
    var _user = loggedInUser();
    var response = await apiBaseHelper.get(
        url: '${ApiUtil.notificationCounterEndPoint}',
        headers: ApiUtil.headers(
          employeeNumber: _user!.employeeNumber,
          tokenId: _user.tokenId,
        ));
    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    return new NotificationCounter(
      count: response.response!['count'],
      surveyCount: response.response!['surveyCount'],
      pollCount: response.response!['pollCount'],
    );
  }

  Future<List<PushNotificationParticipants>> findAllNotificationParticipants(PushNotification pushNotification) async {

    List<PushNotificationParticipants> _notificationParticipants;

    var _user = loggedInUser();
    var response = await apiBaseHelper.get(
      url: '${ApiUtil.notificationParticipantsEndPoint}',
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        tokenId: _user.tokenId,
        itemKey: pushNotification.itemKey,
      ),
    );

    var list = response.response!['notificationParticipants'] as List;
    _notificationParticipants = list.map((e) => PushNotificationParticipants.fromJson(e)).where((element) =>
     element.employeeNumber != pushNotification.employeeNumber).toList();
    return _notificationParticipants;
  }

  Future<List<NotificationComments>> findAllPushNotificationComments(String itemKey) async {
    List<NotificationComments> _notificationComments;
    var _user = loggedInUser();
    var response = await apiBaseHelper.get(
      url: '${ApiUtil.notificationCommentsEndPoint}',
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        tokenId: _user.tokenId,
        itemKey: itemKey,
      ),
    );
    var list = response.response!['notificationComments'] as List;
    _notificationComments = list.map((e) => NotificationComments.fromJson(e)).toList();
    return _notificationComments;
  }

  Future<String> createInformationRequest(Map<String, dynamic> requestBody, String itemKey) async {
    print(requestBody);
    var _user = loggedInUser();
    var response = await apiBaseHelper.post(
      url: '${ApiUtil.moreInformationRequestEndPoint}',
      body: requestBody,
      headers: ApiUtil.headers(
        employeeNumber: _user!.employeeNumber,
        tokenId: _user.tokenId,
        itemKey: itemKey,
      ),
    );

    if (response.errorCode != 200) {
      throw new Exception(response.errorMessage);
    }
    return response.errorMessage;
  }
}
