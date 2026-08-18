import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';

class AuthService {
  static const String _userKey = 'fireguard_user_session';
  static const String _tokenKey = 'auth_token';

  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        return User.fromJson(jsonDecode(userJson));
      } catch (_) {}
    }
    // Default demo user matching Kotlin initial state
    final defaultUser = const User(
      uid: 'usr_001',
      email: 'inspector@fireguard.org',
      displayName: 'Alex Rivera',
      role: 'EHS Manager',
      points: 1250,
      currentLevel: 3,
      streakDays: 5,
      badges: ['Fire Inspector Level 1'],
      unlockedCoupons: ['GRAINGER-20'],
      bookmarkedQuestions: ['q_1_1'],
    );
    await saveUser(defaultUser);
    return defaultUser;
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_tokenKey, 'token_${user.uid}');
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }
}
