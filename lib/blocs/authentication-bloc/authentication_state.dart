import 'package:equatable/equatable.dart';
import 'package:loop_hr/models/user.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final User user;
  const AuthenticationAuthenticated({required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'AuthenticationAuthenticated { user: $user }';
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}
