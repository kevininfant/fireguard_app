import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/common_button.dart';
import 'package:fireguard_app/core/widgets/custom_text_field.dart';
import 'package:fireguard_app/core/utils/validators.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class SetNewPasswordPage extends StatefulWidget {
  final String email;
  final String code;

  const SetNewPasswordPage({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSetNewPassword(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: AppColors.safetyRed,
          ),
        );
        return;
      }
      context.read<AuthBloc>().add(
            AuthSetNewPassword(
              email: widget.email,
              code: widget.code,
              newPassword: _newPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.passwordUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Passcode successfully updated! Please sign in.'),
              backgroundColor: AppColors.successGreen,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.auth, (route) => false);
        } else if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.safetyRed,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.industrialOrange),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceContainerHighest),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.industrialOrange.withValues(alpha: 0.5)),
                            ),
                            child: const Icon(
                              Icons.lock_clock,
                              color: AppColors.industrialOrange,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Set New Passcode',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurfaceText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create a new secure passcode for your clearance account.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariantText,
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomTextField(
                            controller: _newPasswordController,
                            label: 'New Passcode',
                            hintText: 'Enter new passcode',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.onSurfaceVariantText,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: Validators.validatePassword,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm New Passcode',
                            hintText: 'Repeat new passcode',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            validator: (v) => Validators.validateNotEmpty(v, 'Confirm Passcode'),
                          ),
                          const SizedBox(height: 24),
                          CommonButton(
                            text: 'UPDATE PASSCODE & SIGN IN',
                            isLoading: isLoading,
                            icon: Icons.check,
                            onPressed: () => _onSetNewPassword(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
