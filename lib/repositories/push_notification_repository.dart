import 'package:loop_hr/clients/api_clients/push_notification_api_client.dart';
import 'package:loop_hr/models/models.dart';
import 'package:loop_hr/models/push_notification_comments.dart';
import 'package:loop_hr/models/push_notification_participants.dart';

class PushNotificationRepository {
  final PushNotificationApiClient apiClient;

  PushNotificationRepository(this.apiClient);

  Future<List<PushNotification>> findAllPushNotification(int pageNumber) {
    return apiClient.findAllPushNotification(pageNumber);
  }

  // Approvate/Reject Notification
  Future<String> approveOrRejectNotification(Map<String, dynamic> requestBody) {
    return apiClient.approveOrRejectNotification(requestBody);
  }

    Future<String> createInformationRequest(Map<String, dynamic> requestBody, String itemKey) {
    return apiClient.createInformationRequest(requestBody, itemKey);
  }

  // Dismiss Notification
  Future<String> dismissPushNotification(int oidNotification) {
    return apiClient.dismissPushNotification(oidNotification);
  }

  Future notificationCounter() async {
    return apiClient.notificationCounter();
  }

  Future<List<PushNotificationParticipants>> findAllNotificationParticipants(PushNotification pushNotification) {
    return apiClient.findAllNotificationParticipants(pushNotification);
  }

    Future<List<NotificationComments>> findAllNotificationComments(String itemKey) {
    return apiClient.findAllPushNotificationComments(itemKey);
  }
} 
