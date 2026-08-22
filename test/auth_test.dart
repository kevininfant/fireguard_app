import 'package:flutter_test/flutter_test.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';
import 'package:fireguard_app/features/auth/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

void main() {
  group('User Model Dynamic Firestore Serialization Tests', () {
    test('User fromJson parses standard Firestore document correctly', () {
      final json = {
        'uid': 'user_123_abc',
        'email': 'safety.officer@domain.org',
        'displayName': 'Chief Alex Rivera',
        'role': 'EHS Manager',
        'points': 750,
        'currentLevel': 2,
        'streakDays': 4,
        'badges': ['Safety Trainee', 'Fire Inspector Level 1'],
        'unlockedCoupons': ['GRAINGER-20'],
        'bookmarkedQuestions': ['q1', 'q2'],
      };

      final user = User.fromJson(json);

      expect(user.uid, 'user_123_abc');
      expect(user.email, 'safety.officer@domain.org');
      expect(user.displayName, 'Chief Alex Rivera');
      expect(user.role, 'EHS Manager');
      expect(user.points, 750);
      expect(user.currentLevel, 2);
      expect(user.streakDays, 4);
      expect(user.badges, contains('Fire Inspector Level 1'));
      expect(user.unlockedCoupons, contains('GRAINGER-20'));
      expect(user.bookmarkedQuestions, contains('q1'));
    });

    test('User fromJson handles missing/empty Firestore fields gracefully', () {
      final json = <String, dynamic>{
        'uid': 'user_999',
        'email': 'inspector@fireguard.org',
      };

      final user = User.fromJson(json);

      expect(user.uid, 'user_999');
      expect(user.email, 'inspector@fireguard.org');
      expect(user.displayName, 'inspector');
      expect(user.role, 'Safety Inspector');
      expect(user.points, 500);
      expect(user.currentLevel, 1);
      expect(user.streakDays, 1);
      expect(user.badges, contains('Safety Trainee'));
    });

    test('User toJson produces valid Map with all properties', () {
      const user = User(
        uid: 'uid_test',
        email: 'test@fireguard.org',
        displayName: 'Test User',
        role: 'Fire Officer',
        points: 600,
        currentLevel: 1,
        streakDays: 2,
        badges: ['Safety Trainee'],
      );

      final json = user.toJson();

      expect(json['uid'], 'uid_test');
      expect(json['email'], 'test@fireguard.org');
      expect(json['displayName'], 'Test User');
      expect(json['role'], 'Fire Officer');
      expect(json['points'], 600);
    });

    test('User copyWith updates fields properly', () {
      const user = User(
        uid: 'uid_1',
        email: 'u1@test.com',
        displayName: 'Old Name',
        role: 'Safety Inspector',
      );

      final updated = user.copyWith(
        displayName: 'New Name',
        role: 'EHS Manager',
        points: 800,
      );

      expect(updated.displayName, 'New Name');
      expect(updated.role, 'EHS Manager');
      expect(updated.points, 800);
      expect(updated.uid, 'uid_1');
    });
  });

  group('FirebaseAuth Error Code Translation Tests', () {
    test('Translates common FirebaseAuthException error codes correctly', () {
      expect(
        AuthService.readableFirebaseAuthError(
          fb.FirebaseAuthException(code: 'user-not-found'),
        ),
        'No clearance account found for this email. Please register first.',
      );

      expect(
        AuthService.readableFirebaseAuthError(
          fb.FirebaseAuthException(code: 'invalid-credential'),
        ),
        'Invalid email or security passcode. Please check your credentials.',
      );

      expect(
        AuthService.readableFirebaseAuthError(
          fb.FirebaseAuthException(code: 'email-already-in-use'),
        ),
        'An account already exists for this email. Please sign in instead.',
      );

      expect(
        AuthService.readableFirebaseAuthError(
          fb.FirebaseAuthException(code: 'weak-password'),
        ),
        'Passcode is too weak. Please use at least 6 characters.',
      );

      expect(
        AuthService.readableFirebaseAuthError(
          fb.FirebaseAuthException(code: 'network-request-failed'),
        ),
        'Network connection error. Please check your internet connectivity.',
      );
    });
  });
}
