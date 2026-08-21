import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/common_button.dart';
import 'package:fireguard_app/core/widgets/custom_text_field.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/settings/bloc/settings_bloc.dart';
import 'package:fireguard_app/features/settings/bloc/settings_event.dart';
import 'package:fireguard_app/features/settings/bloc/settings_state.dart';
import 'package:fireguard_app/features/settings/widgets/settings_switch_card.dart';

class SettingsPage extends StatefulWidget {
  final bool isStandalone;

  const SettingsPage({super.key, this.isStandalone = false});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsBloc>().state.settings;
    _nameController = TextEditingController(text: settings.displayName);
    _roleController = TextEditingController(text: settings.designation);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final settings = state.settings;

        final body = SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Officer Profile Settings
              const Text(
                'OFFICER PROFILE & CLEARANCE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: AppColors.onSurfaceVariantText,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceContainerHighest),
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Display Name',
                      hintText: 'Alex Rivera',
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _roleController,
                      label: 'Official Designation',
                      hintText: 'EHS Manager',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: Experience & Sound Preferences
              const Text(
                'APP PREFERENCES & ACCESSIBILITY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: AppColors.onSurfaceVariantText,
                ),
              ),
              const SizedBox(height: 10),
              SettingsSwitchCard(
                title: 'Industrial Dark Theme',
                subtitle: 'High contrast dark mode for emergency response',
                icon: Icons.dark_mode,
                value: settings.darkModeEnabled,
                onChanged: (v) {
                  context.read<SettingsBloc>().add(
                    SettingsUpdated(settings.copyWith(darkModeEnabled: v)),
                  );
                },
              ),
              const SizedBox(height: 8),
              SettingsSwitchCard(
                title: 'Sound Effects (SFX)',
                subtitle: 'Audio feedback on correct answers and alerts',
                icon: Icons.volume_up,
                value: settings.sfxEnabled,
                onChanged: (v) {
                  context.read<SettingsBloc>().add(
                    SettingsUpdated(settings.copyWith(sfxEnabled: v)),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Save Settings Button
              CommonButton(
                text: 'SAVE ALL SETTINGS',
                icon: Icons.save,
                onPressed: () {
                  final updated = settings.copyWith(
                    displayName: _nameController.text.trim(),
                    designation: _roleController.text.trim(),
                  );
                  context.read<SettingsBloc>().add(SettingsUpdated(updated));

                  final user = context.read<AuthBloc>().state.user;
                  if (user != null) {
                    final updatedUser = user.copyWith(
                      displayName: _nameController.text.trim(),
                      role: _roleController.text.trim(),
                    );
                    context.read<AuthBloc>().add(AuthUserUpdated(updatedUser));
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved successfully!'),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                },
              ),
            ],
          ),
        );

        if (widget.isStandalone) {
          return Scaffold(
            backgroundColor: AppColors.darkBackground,
            appBar: AppBar(
              title: const Text('Settings'),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.industrialOrange,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: body,
          );
        }

        return body;
      },
    );
  }
}
