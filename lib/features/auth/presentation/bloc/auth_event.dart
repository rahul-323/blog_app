part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String password;
  final String email;

  AuthSignUp({
    required this.name,
    required this.password,
    required this.email,
  });
}

final class AuthLogin extends AuthEvent {
  final String password;
  final String email;

  AuthLogin({
    required this.password,
    required this.email,
  });
}

final class AuthUserIsLoggedIn extends AuthEvent {}
