import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckStatus extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;
  final String? displayName;

  const AuthLoginRequested({
    required this.email,
    required this.password,
    required this.role,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, role, displayName];
}

class AuthSignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String role;

  const AuthSignUpRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [fullName, email, password, role];
}

class AuthRoleChanged extends AuthEvent {
  final String role;
  const AuthRoleChanged(this.role);

  @override
  List<Object?> get props => [role];
}

class AuthSendResetCode extends AuthEvent {
  final String email;
  const AuthSendResetCode(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthVerifyResetCode extends AuthEvent {
  final String email;
  final String code;
  const AuthVerifyResetCode({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}

class AuthSetNewPassword extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;
  const AuthSetNewPassword({required this.email, required this.code, required this.newPassword});

  @override
  List<Object?> get props => [email, code, newPassword];
}

class AuthUserUpdated extends AuthEvent {
  final User user;
  const AuthUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {}
