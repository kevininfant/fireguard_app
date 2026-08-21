import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';

class AuthService {
  static const String _userKey = 'fireguard_user_session';
  static const String _accountsKey = 'fireguard_accounts';
  static const String _resetCodesKey = 'fireguard_reset_codes';
  static const String _tokenKey = 'auth_token';

  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        return User.fromJson(jsonDecode(userJson));
      } catch (_) {}
    }
    return null;
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_tokenKey, 'token_${user.uid}');
  }

  Future<User?> getAccountUser(String email) async {
    final account = await _getAccount(email);
    if (account == null) return null;
    return User.fromJson(Map<String, dynamic>.from(account['user'] as Map));
  }

  Future<bool> hasAccount(String email) async {
    return await _getAccount(email) != null;
  }

  Future<bool> isValidPassword(String email, String password) async {
    final account = await _getAccount(email);
    return account?['password'] == password;
  }

  Future<void> saveAccount({
    required User user,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await _getAccounts();
    accounts[_normalizeEmail(user.email)] = {
      'password': password,
      'user': user.toJson(),
    };
    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  Future<void> updateAccountUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await _getAccounts();
    final emailKey = _normalizeEmail(user.email);
    final existing = accounts[emailKey];
    if (existing == null) return;

    accounts[emailKey] = {...existing, 'user': user.toJson()};
    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  Future<void> updatePassword(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await _getAccounts();
    final emailKey = _normalizeEmail(email);
    final existing = accounts[emailKey];
    if (existing == null) {
      throw Exception('No account found for this email.');
    }

    accounts[emailKey] = {...existing, 'password': password};
    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  Future<void> saveResetCode({
    required String email,
    required String code,
    required DateTime expiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final resetCodes = await _getResetCodes();
    resetCodes[_normalizeEmail(email)] = {
      'code': code,
      'expiresAt': expiresAt.toIso8601String(),
    };
    await prefs.setString(_resetCodesKey, jsonEncode(resetCodes));
  }

  Future<String?> getValidResetCode(String email) async {
    final resetCodes = await _getResetCodes();
    final resetCode = resetCodes[_normalizeEmail(email)];
    if (resetCode is! Map) return null;

    final data = Map<String, dynamic>.from(resetCode);
    final code = data['code'] as String?;
    final expiresAt = DateTime.tryParse(data['expiresAt'] as String? ?? '');
    if (code == null || expiresAt == null || DateTime.now().isAfter(expiresAt)) {
      await clearResetCode(email);
      return null;
    }

    return code;
  }

  Future<void> clearResetCode(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final resetCodes = await _getResetCodes();
    resetCodes.remove(_normalizeEmail(email));
    await prefs.setString(_resetCodesKey, jsonEncode(resetCodes));
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  Future<Map<String, dynamic>> _getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getString(_accountsKey);
    if (accountsJson == null) return {};

    try {
      return Map<String, dynamic>.from(jsonDecode(accountsJson) as Map);
    } catch (_) {
      return {};
    }
  }

  Future<Map<String, dynamic>> _getResetCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final resetCodesJson = prefs.getString(_resetCodesKey);
    if (resetCodesJson == null) return {};

    try {
      return Map<String, dynamic>.from(jsonDecode(resetCodesJson) as Map);
    } catch (_) {
      return {};
    }
  }

  Future<Map<String, dynamic>?> _getAccount(String email) async {
    final accounts = await _getAccounts();
    final account = accounts[_normalizeEmail(email)];
    if (account is Map) {
      return Map<String, dynamic>.from(account);
    }
    return null;
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();
}
