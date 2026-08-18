import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/features/profile/bloc/profile_bloc.dart';
import 'package:fireguard_app/features/profile/bloc/profile_state.dart';
import 'package:fireguard_app/features/profile/widgets/badge_grid_card.dart';

class BadgesPage extends StatelessWidget {
  const BadgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Officer Merit Badges'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.industrialOrange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemCount: state.badges.length,
            itemBuilder: (context, index) {
              return BadgeGridCard(badge: state.badges[index]);
            },
          );
        },
      ),
    );
  }
}
