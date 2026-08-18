import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/features/auth/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthState()) {
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthRoleChanged>(_onRoleChanged);
    on<AuthSendResetCode>(_onSendResetCode);
    on<AuthVerifyResetCode>(_onVerifyResetCode);
    on<AuthSetNewPassword>(_onSetNewPassword);
    on<AuthUserUpdated>(_onUserUpdated);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          selectedRole: user.role,
        ));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _authRepository.login(
        email: event.email,
        password: event.password,
        role: event.role,
        displayName: event.displayName,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        selectedRole: user.role,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _authRepository.signUp(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        role: event.role,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        selectedRole: user.role,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onRoleChanged(
    AuthRoleChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(selectedRole: event.role));
  }

  Future<void> _onSendResetCode(
    AuthSendResetCode event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.sendPasswordResetOtp(event.email);
      emit(state.copyWith(
        status: AuthStatus.codeSent,
        resetEmail: event.email,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onVerifyResetCode(
    AuthVerifyResetCode event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final isValid = await _authRepository.verifyOtp(event.email, event.code);
      if (isValid) {
        emit(state.copyWith(status: AuthStatus.codeVerified));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid verification code. Please enter 6 digits.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSetNewPassword(
    AuthSetNewPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.setNewPassword(event.email, event.newPassword);
      emit(state.copyWith(status: AuthStatus.passwordUpdated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.updateUser(event.user);
    emit(state.copyWith(user: event.user));
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
