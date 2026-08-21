import 'dart:math';

import 'package:fireguard_app/features/auth/data/models/user_model.dart';
import 'package:fireguard_app/features/auth/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  Future<User?> getCurrentUser() async {
    return await _authService.getSavedUser();
  }

  Future<User> login({
    required String email,
    required String password,
    required String role,
    String? displayName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final user = await _authService.getAccountUser(email);
    if (user == null) {
      throw Exception(
        'No account found for this email. Please register first.',
      );
    }

    final isPasswordValid = await _authService.isValidPassword(email, password);
    if (!isPasswordValid) {
      throw Exception('Invalid email or passcode.');
    }

    await _authService.saveUser(user);
    return user;
  }

  Future<User> signUp({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final normalizedEmail = email.trim().toLowerCase();
    final accountExists = await _authService.hasAccount(normalizedEmail);
    if (accountExists) {
      throw Exception(
        'An account already exists for this email. Please sign in.',
      );
    }

    final user = User(
      uid: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: normalizedEmail,
      displayName: fullName,
      role: role,
      points: 500, // Welcome bonus points
      currentLevel: 1,
      streakDays: 1,
      badges: const ['Safety Trainee'],
      unlockedCoupons: const [],
      bookmarkedQuestions: const [],
    );
    await _authService.saveAccount(user: user, password: password);
    await _authService.saveUser(user);
    return user;
  }

  Future<String> sendPasswordResetOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final exists = await _authService.hasAccount(email);
    if (!exists) {
      throw Exception('No account found for this email.');
    }

    final code = _generateResetCode();
    await _authService.saveResetCode(
      email: email,
      code: code,
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
    );
    return code;
  }

  Future<bool> verifyOtp(String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!RegExp(r'^\d{6}$').hasMatch(code)) return false;

    final savedCode = await _authService.getValidResetCode(email);
    return savedCode == code;
  }

  Future<void> setNewPassword(String email, String code, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final isValid = await verifyOtp(email, code);
    if (!isValid) {
      throw Exception('Invalid or expired verification code.');
    }

    await _authService.updatePassword(email, newPassword);
    await _authService.clearResetCode(email);
  }

  Future<void> updateUser(User user) async {
    await _authService.saveUser(user);
    await _authService.updateAccountUser(user);
  }

  Future<void> logout() async {
    await _authService.clearUser();
  }

  String _generateResetCode() {
    final random = Random.secure();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }
}
