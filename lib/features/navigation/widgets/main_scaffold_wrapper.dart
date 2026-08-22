import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/features/dashboard/pages/dashboard_page.dart';
import 'package:fireguard_app/features/dashboard/widgets/officer_profile_dialog.dart';
import 'package:fireguard_app/features/feed/pages/feed_page.dart';
import 'package:fireguard_app/features/leaderboard/pages/leaderboard_page.dart';
import 'package:fireguard_app/features/admob/pages/admob_page.dart';
import 'package:fireguard_app/features/navigation/widgets/fireguard_top_bar.dart';
import 'package:fireguard_app/features/navigation/widgets/fireguard_bottom_nav.dart';
import 'package:fireguard_app/features/navigation/widgets/sidebar_drawer.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class MainScaffoldWrapper extends StatefulWidget {
  final int initialTabIndex;

  const MainScaffoldWrapper({super.key, this.initialTabIndex = 0});

  @override
  State<MainScaffoldWrapper> createState() => _MainScaffoldWrapperState();
}

class _MainScaffoldWrapperState extends State<MainScaffoldWrapper> {
  late int _currentTabIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
  }

  String _getCurrentRouteName() {
    switch (_currentTabIndex) {
      case 0:
        return AppRoutes.dashboard;
      case 1:
        return AppRoutes.feed;
      case 2:
        return AppRoutes.leaderboard;
      case 3:
        return AppRoutes.admob;
      default:
        return AppRoutes.dashboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        final screens = const [
          DashboardPage(),
          FeedPage(),
          LeaderboardPage(),
          AdMobPage(),
        ];

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.darkBackground,
          drawer: SidebarDrawer(
            user: user,
            currentRoute: _getCurrentRouteName(),
            onNavigate: (route) {
              Navigator.pop(context); // Close drawer
              if (route == AppRoutes.dashboard) {
                setState(() => _currentTabIndex = 0);
              } else if (route == AppRoutes.feed) {
                setState(() => _currentTabIndex = 1);
              } else if (route == AppRoutes.leaderboard) {
                setState(() => _currentTabIndex = 2);
              } else if (route == AppRoutes.admob || route == AppRoutes.rewards) {
                setState(() => _currentTabIndex = 3);
              } else {
                Navigator.pushNamed(context, route);
              }
            },
            onLogout: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.auth, (route) => false);
            },
          ),
          appBar: FireGuardTopBar(
            title: 'FireGuard Safety',
            userRole: user?.role,
            onOpenDrawer: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            onProfileClick: () {
              showDialog(
                context: context,
                builder: (_) => OfficerProfileDialog(
                  user: user,
                  onLogout: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.auth, (route) => false);
                  },
                ),
              );
            },
          ),
          body: IndexedStack(
            index: _currentTabIndex,
            children: screens,
          ),
          bottomNavigationBar: FireGuardBottomNav(
            currentIndex: _currentTabIndex,
            onTabSelected: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
