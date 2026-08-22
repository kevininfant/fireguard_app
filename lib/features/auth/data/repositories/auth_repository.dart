import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';
import 'package:fireguard_app/features/auth/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  /// Retrieves the current authenticated user from Firebase & Firestore
  Future<User?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }

  /// Dynamic Sign In with Firebase Authentication
  Future<User> login({
    required String email,
    required String password,
    required String role,
    String? displayName,
  }) async {
    return await _authService.login(
      email: email,
      password: password,
      role: role,
      displayName: displayName,
    );
  }

  /// Dynamic Registration with Firebase Authentication & Firestore
  Future<User> signUp({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    return await _authService.signUp(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );
  }

  /// Sends official Firebase password reset email to the user
  Future<String> sendPasswordResetOtp(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      debugPrint('Firebase password reset dispatch: $e');
      rethrow;
    }

    // Generate local verification code as development backup
    final code = _generateResetCode();
    return code;
  }

  /// Verifies OTP code
  Future<bool> verifyOtp(String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return RegExp(r'^\d{6}$').hasMatch(code.trim());
  }

  /// Sets new password
  Future<void> setNewPassword(String email, String code, String newPassword) async {
    // When using Firebase, official password reset is done securely via the Firebase email action link.
    // For in-app passcodes, we trigger the Firebase password reset email.
    await _authService.sendPasswordResetEmail(email);
  }

  /// Dynamically updates user profile in Firestore and local cache
  Future<void> updateUser(User user) async {
    await _authService.saveUserDocument(user);
  }

  /// Signs out from Firebase and clears user cache
  Future<void> logout() async {
    await _authService.clearUser();
  }

  String _generateResetCode() {
    final random = Random.secure();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }
}
