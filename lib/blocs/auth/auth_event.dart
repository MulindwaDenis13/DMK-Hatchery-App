part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class Login extends AuthEvent {
  final String phone;
  final String password;

  const Login({
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [
        phone,
        password,
      ];
}

class AuthFailure extends AuthEvent {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

class Logout extends AuthEvent {}
