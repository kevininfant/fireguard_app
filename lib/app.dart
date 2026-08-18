import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/theme/app_theme.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_event.dart';
import 'package:fireguard_app/features/feed/bloc/feed_bloc.dart';
import 'package:fireguard_app/features/feed/bloc/feed_event.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_bloc.dart';
import 'package:fireguard_app/features/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:fireguard_app/features/leaderboard/bloc/leaderboard_event.dart';
import 'package:fireguard_app/features/rewards/bloc/rewards_bloc.dart';
import 'package:fireguard_app/features/rewards/bloc/rewards_event.dart';
import 'package:fireguard_app/features/profile/bloc/profile_bloc.dart';
import 'package:fireguard_app/features/profile/bloc/profile_event.dart';
import 'package:fireguard_app/features/settings/bloc/settings_bloc.dart';
import 'package:fireguard_app/features/settings/bloc/settings_event.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class FireGuardApp extends StatelessWidget {
  const FireGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AuthCheckStatus())),
        BlocProvider(create: (_) => DashboardBloc()..add(DashboardStarted())),
        BlocProvider(create: (_) => FeedBloc()..add(FeedStarted())),
        BlocProvider(create: (_) => QuizBloc()),
        BlocProvider(create: (_) => LeaderboardBloc()..add(LeaderboardStarted())),
        BlocProvider(create: (_) => RewardsBloc()..add(RewardsStarted())),
        BlocProvider(create: (_) => ProfileBloc()..add(ProfileStarted())),
        BlocProvider(create: (_) => SettingsBloc()..add(SettingsStarted())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FireGuard Safety',
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
