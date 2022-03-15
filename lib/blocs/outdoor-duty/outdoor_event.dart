import 'package:equatable/equatable.dart';

abstract class OutDoorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateOutDoor extends OutDoorEvent {
  final Map<String, dynamic> requestBody;
  CreateOutDoor(this.requestBody);
}
