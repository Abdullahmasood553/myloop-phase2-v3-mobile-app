import 'package:equatable/equatable.dart';

import 'package:loop_hr/models/outdoor_duty.dart';

abstract class OutDoorState extends Equatable {
  @override
  List<Object> get props => [];
}

class OutDoorInitial extends OutDoorState {}

class OutDoorLoading extends OutDoorState {}

class OutDoorLoaded extends OutDoorState {
  final List<OutDoorDuty> data;
  OutDoorLoaded(this.data);

  List<Object> get props => [data];
}

class OutDoorError extends OutDoorState {
  final String message;
  OutDoorError(this.message);

  List<Object> get props => [message];
}

class OutDoorCreated extends OutDoorState {
  final String message;

  OutDoorCreated(this.message);

  List<Object> get props => [message];
}

class CreateOutDoorLoading extends OutDoorState {}

class CreateOutDoorSuccess extends OutDoorState {
  final String message;
  CreateOutDoorSuccess(this.message);
  List<Object> get props => [];
}

class CreateOutDoorError extends OutDoorState {
  final String message;
  CreateOutDoorError(this.message);
}
