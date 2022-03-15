import 'package:equatable/equatable.dart';

abstract class NotificationInformationState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationInformationInitial extends NotificationInformationState {}

class NotificationInformationLoading extends NotificationInformationState {}

class NotificationInformationSuccess extends NotificationInformationState {
  final String message;
  NotificationInformationSuccess(this.message);
  List<Object> get props => [message];
}


class NotificationInformationError extends NotificationInformationState {
  final String message;
  NotificationInformationError(this.message);
}


