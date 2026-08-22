import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';

class AuthService {
  static const String _userKey = 'fireguard_user_session';
  static const String _tokenKey = 'auth_token';
  static const String _usersCollection = 'users';

  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    fb.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream of Firebase auth state changes
  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  /// Gets the currently authenticated user from Firebase Auth & Firestore
  Future<User?> getCurrentUser() async {
    try {
      final fbUser = _auth.currentUser;
      if (fbUser == null) {
        // If not authenticated in Firebase, check local cache fallback
        return await getSavedUser();
      }

      // Fetch dynamic user document from Firestore
      final userDoc = await _firestore
          .collection(_usersCollection)
          .doc(fbUser.uid)
          .get()
          .timeout(const Duration(seconds: 6));

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        final user = User.fromJson({
          ...data,
          'uid': fbUser.uid,
          'email': fbUser.email ?? (data['email'] ?? ''),
        });
        await saveUser(user);
        return user;
      }

      // If document does not exist yet in Firestore, create default entry
      final defaultUser = User(
        uid: fbUser.uid,
        email: fbUser.email ?? '',
        displayName: fbUser.displayName?.isNotEmpty == true
            ? fbUser.displayName!
            : (fbUser.email?.split('@').first ?? 'Safety Inspector'),
        role: 'Safety Inspector',
        points: 500,
        currentLevel: 1,
        streakDays: 1,
        badges: const ['Safety Trainee'],
      );

      await saveUserDocument(defaultUser);
      return defaultUser;
    } catch (e) {
      debugPrint('AuthService getCurrentUser exception: $e');
      // Fallback to local session cache on network issues
      return await getSavedUser();
    }
  }

  /// Dynamic Sign In with Firebase Authentication and Firestore User Fetch
  Future<User> login({
    required String email,
    required String password,
    required String role,
    String? displayName,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final fbUser = userCredential.user;
      if (fbUser == null) {
        throw Exception('Sign in succeeded but user object was null.');
      }

      // Dynamic fetch from Firestore
      User user;
      try {
        final docRef = _firestore.collection(_usersCollection).doc(fbUser.uid);
        final docSnap = await docRef.get().timeout(const Duration(seconds: 6));

        if (docSnap.exists && docSnap.data() != null) {
          final data = docSnap.data()!;
          user = User.fromJson({
            ...data,
            'uid': fbUser.uid,
            'email': fbUser.email ?? normalizedEmail,
          });

          // Sync lastLoginAt and any updated metadata
          await docRef.set({
            'lastLoginAt': FieldValue.serverTimestamp(),
            if (role.isNotEmpty) 'role': role,
            if (displayName != null && displayName.isNotEmpty)
              'displayName': displayName,
          }, SetOptions(merge: true));

          if (role.isNotEmpty || (displayName != null && displayName.isNotEmpty)) {
            user = user.copyWith(
              role: role.isNotEmpty ? role : user.role,
              displayName: displayName?.isNotEmpty == true
                  ? displayName
                  : user.displayName,
            );
          }
        } else {
          // Document didn't exist in Firestore (e.g. created outside app)
          user = User(
            uid: fbUser.uid,
            email: fbUser.email ?? normalizedEmail,
            displayName: displayName?.isNotEmpty == true
                ? displayName!
                : (fbUser.displayName?.isNotEmpty == true
                    ? fbUser.displayName!
                    : normalizedEmail.split('@').first),
            role: role.isNotEmpty ? role : 'Safety Inspector',
            points: 500,
            currentLevel: 1,
            streakDays: 1,
            badges: const ['Safety Trainee'],
          );
          await saveUserDocument(user);
        }
      } catch (firestoreError) {
        debugPrint('Firestore fetch during login notice: $firestoreError');
        // Construct fallback user from auth credentials
        user = User(
          uid: fbUser.uid,
          email: fbUser.email ?? normalizedEmail,
          displayName: fbUser.displayName ?? normalizedEmail.split('@').first,
          role: role.isNotEmpty ? role : 'Safety Inspector',
        );
      }

      await saveUser(user);
      return user;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(readableFirebaseAuthError(e));
    } catch (e) {
      throw Exception(readableGenericError(e));
    }
  }

  /// Dynamic Sign Up with Firebase Authentication and Firestore User Creation
  Future<User> signUp({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final fbUser = userCredential.user;
      if (fbUser == null) {
        throw Exception('Sign up succeeded but user object was null.');
      }

      // Update Firebase Auth display name profile
      try {
        await fbUser.updateDisplayName(fullName.trim());
      } catch (e) {
        debugPrint('Failed to update Firebase user display name: $e');
      }

      final newUser = User(
        uid: fbUser.uid,
        email: normalizedEmail,
        displayName: fullName.trim().isNotEmpty
            ? fullName.trim()
            : normalizedEmail.split('@').first,
        role: role.isNotEmpty ? role : 'Safety Inspector',
        points: 500, // 500 Welcome bonus safety points
        currentLevel: 1,
        streakDays: 1,
        badges: const ['Safety Trainee'],
        unlockedCoupons: const [],
        bookmarkedQuestions: const [],
      );

      // Save user document dynamically to Firestore
      try {
        await saveUserDocument(newUser);
      } catch (firestoreError) {
        debugPrint('Firestore user document save notice: $firestoreError');
      }

      await saveUser(newUser);
      return newUser;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(readableFirebaseAuthError(e));
    } catch (e) {
      throw Exception(readableGenericError(e));
    }
  }

  /// Dynamic Password Reset Email dispatch via Firebase Auth
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      await _auth.sendPasswordResetEmail(email: normalizedEmail);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(readableFirebaseAuthError(e));
    } catch (e) {
      throw Exception(readableGenericError(e));
    }
  }

  /// Updates User in Firestore & local cache
  Future<void> saveUserDocument(User user) async {
    try {
      final docData = {
        ...user.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(docData, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Firestore saveUserDocument error: $e');
    }
    await saveUser(user);
  }

  /// Saves user session locally in SharedPreferences for offline caching
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_tokenKey, 'token_${user.uid}');
  }

  /// Gets cached user session from SharedPreferences
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

  /// Clears local user cache and signs out from Firebase
  Future<void> clearUser() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Firebase sign out notice: $e');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  /// Friendly error parser for Firebase Auth exceptions
  static String readableFirebaseAuthError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No clearance account found for this email. Please register first.';
      case 'wrong-password':
        return 'Incorrect security passcode. Please verify your passcode.';
      case 'invalid-credential':
        return 'Invalid email or security passcode. Please check your credentials.';
      case 'email-already-in-use':
        return 'An account already exists for this email. Please sign in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Passcode is too weak. Please use at least 6 characters.';
      case 'user-disabled':
        return 'This clearance ID has been disabled. Please contact safety support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network connection error. Please check your internet connectivity.';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled in Firebase Authentication.';
      default:
        return e.message ?? 'Authentication failed (${e.code}). Please try again.';
    }
  }

  /// Friendly error parser for generic errors
  static String readableGenericError(Object error) {
    final errStr = error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
    return errStr;
  }
}
