import 'package:flutter/material.dart';
import 'package:fireguard_app/features/auth/pages/auth_page.dart';
import 'package:fireguard_app/features/auth/pages/sign_up_page.dart';
import 'package:fireguard_app/features/auth/pages/reset_password_page.dart';
import 'package:fireguard_app/features/auth/pages/verify_code_page.dart';
import 'package:fireguard_app/features/auth/pages/set_new_password_page.dart';
import 'package:fireguard_app/features/navigation/widgets/main_scaffold_wrapper.dart';
import 'package:fireguard_app/features/quiz/pages/quiz_page.dart';
import 'package:fireguard_app/features/quiz/pages/quiz_results_page.dart';
import 'package:fireguard_app/features/profile/pages/profile_page.dart';
import 'package:fireguard_app/features/profile/pages/badges_page.dart';
import 'package:fireguard_app/features/profile/pages/bookmarked_questions_page.dart';
import 'package:fireguard_app/features/settings/pages/settings_page.dart';
import 'package:fireguard_app/features/settings/pages/help_support_page.dart';
import 'package:fireguard_app/features/splash/pages/splash_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String auth = '/auth';
  static const String signUp = '/sign-up';
  static const String resetPassword = '/reset-password';
  static const String verifyCode = '/verify-code';
  static const String setNewPassword = '/set-new-password';
  static const String dashboard = '/dashboard';
  static const String feed = '/feed';
  static const String leaderboard = '/leaderboard';
  static const String rewards = '/rewards';
  static const String quiz = '/quiz';
  static const String quizResults = '/quiz-results';
  static const String profile = '/profile';
  static const String badges = '/badges';
  static const String bookmarks = '/bookmarks';
  static const String settings = '/settings';
  static const String help = '/help';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());

      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordPage());

      case verifyCode:
        final args = routeSettings.arguments;
        final email = args is Map<String, dynamic>
            ? args['email'] as String? ?? ''
            : args as String? ?? '';
        final code = args is Map<String, dynamic> ? args['code'] as String? : null;
        return MaterialPageRoute(
          builder: (_) => VerifyCodePage(email: email, recoveryCode: code),
        );

      case setNewPassword:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => SetNewPasswordPage(
            email: args['email'] ?? '',
            code: args['code'] ?? '',
          ),
        );

      case dashboard:
        return MaterialPageRoute(builder: (_) => const MainScaffoldWrapper(initialTabIndex: 0));

      case feed:
        return MaterialPageRoute(builder: (_) => const MainScaffoldWrapper(initialTabIndex: 1));

      case leaderboard:
        return MaterialPageRoute(builder: (_) => const MainScaffoldWrapper(initialTabIndex: 2));

      case rewards:
        return MaterialPageRoute(builder: (_) => const MainScaffoldWrapper(initialTabIndex: 3));

      case quiz:
        final levelId = routeSettings.arguments as int? ?? 1;
        return MaterialPageRoute(builder: (_) => QuizPage(levelId: levelId));

      case quizResults:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => QuizResultsPage(
            levelId: args['levelId'] ?? 1,
            pointsEarned: args['pointsEarned'] ?? 150,
            accuracyPercent: args['accuracyPercent'] ?? 100,
          ),
        );

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage(isStandalone: true));

      case badges:
        return MaterialPageRoute(builder: (_) => const BadgesPage());

      case bookmarks:
        return MaterialPageRoute(builder: (_) => const BookmarkedQuestionsPage());

      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage(isStandalone: true));

      case help:
        return MaterialPageRoute(builder: (_) => const HelpSupportPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
