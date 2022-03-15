import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/outdoor-duty/outdoor.dart';
import 'package:loop_hr/repositories/login_repository.dart';
import 'package:loop_hr/repositories/outdoor_repository.dart';

class OutDoorBloc extends Bloc<OutDoorEvent, OutDoorState> {
  final OutDoorRepository repository;
  final LoginRepository loginRepository;

  OutDoorBloc(this.repository, this.loginRepository) : super(OutDoorInitial()) {
    on<OutDoorEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(OutDoorEvent event, Emitter<OutDoorState> emit) async {
    if (event is CreateOutDoor) {
      try {
        emit(CreateOutDoorLoading());
        await repository.createOutDoor(event.requestBody);
        emit(CreateOutDoorSuccess('Out Door Duty has been submitted for approval'));
      } catch (e) {
        emit(CreateOutDoorError(e.toString()));
      }
    }
  }
}
