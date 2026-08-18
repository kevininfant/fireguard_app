import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error, codeSent, codeVerified, passwordUpdated }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String selectedRole;
  final String? errorMessage;
  final String? resetEmail;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.selectedRole = 'EHS Manager',
    this.errorMessage,
    this.resetEmail,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? selectedRole,
    String? errorMessage,
    String? resetEmail,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      selectedRole: selectedRole ?? this.selectedRole,
      errorMessage: errorMessage,
      resetEmail: resetEmail ?? this.resetEmail,
    );
  }

  @override
  List<Object?> get props => [status, user, selectedRole, errorMessage, resetEmail];
}
