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
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate auth handshake
    final user = User(
      uid: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email.isNotEmpty ? email : 'inspector@fireguard.org',
      displayName: displayName?.isNotEmpty == true ? displayName! : 'Lead Inspector',
      role: role.isNotEmpty ? role : 'EHS Manager',
      points: 1250,
      currentLevel: 3,
      streakDays: 5,
      badges: const ['Fire Inspector Level 1'],
      unlockedCoupons: const ['GRAINGER-20'],
      bookmarkedQuestions: const ['q_1_1'],
    );
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
    final user = User(
      uid: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: fullName,
      role: role,
      points: 500, // Welcome bonus points
      currentLevel: 1,
      streakDays: 1,
      badges: const ['Safety Trainee'],
      unlockedCoupons: const [],
      bookmarkedQuestions: const [],
    );
    await _authService.saveUser(user);
    return user;
  }

  Future<void> sendPasswordResetOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<bool> verifyOtp(String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return code.length == 6 || code == '123456';
  }

  Future<void> setNewPassword(String email, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> updateUser(User user) async {
    await _authService.saveUser(user);
  }

  Future<void> logout() async {
    await _authService.clearUser();
  }
}
