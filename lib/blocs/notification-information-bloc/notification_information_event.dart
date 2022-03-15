import 'package:equatable/equatable.dart';

abstract class NotificationInformationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//dismiss
class DismissNotification extends NotificationInformationEvent {
  final int oidNotification;
  DismissNotification(this.oidNotification);
}

//aproveorreject
class CreateApproveRejectNotification extends NotificationInformationEvent {
  final Map<String, dynamic> requestBody;
  CreateApproveRejectNotification(this.requestBody);
}

// requestinformation
class CreateInformationRequest extends NotificationInformationEvent {
  final String itemKey;
  final Map<String, dynamic> requestBody;
  CreateInformationRequest(this.requestBody, this.itemKey);
}


