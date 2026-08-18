import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/constants/asset_paths.dart';
import 'package:fireguard_app/core/widgets/common_button.dart';
import 'package:fireguard_app/core/widgets/custom_text_field.dart';
import 'package:fireguard_app/core/utils/validators.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/features/auth/widgets/role_selector_card.dart';
import 'package:fireguard_app/features/auth/widgets/sso_button.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'inspector@fireguard.org');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.disposeNavigator();
    super.dispose();
  }

  void _onLogin(BuildContext context, String role) {
    if (_formKey.currentState?.validate() == true) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              role: role,
              displayName: 'Lead Inspector',
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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
        final selectedRole = state.selectedRole;

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceContainerHighest),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Container
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.industrialOrange.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Image.network(
                                  AssetPaths.logoUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.local_fire_department,
                                    color: AppColors.industrialOrange,
                                    size: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'FireGuard Safety',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurfaceText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Workplace Safety & Compliance Certification',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariantText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Form Section
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                RoleSelectorCard(
                                  selectedRole: selectedRole,
                                  onRoleSelected: (role) {
                                    context.read<AuthBloc>().add(AuthRoleChanged(role));
                                  },
                                ),
                                const SizedBox(height: 18),
                                CustomTextField(
                                  controller: _emailController,
                                  label: 'Clearance ID / Work Email',
                                  hintText: 'inspector@fireguard.org',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.validateEmail,
                                ),
                                const SizedBox(height: 18),
                                CustomTextField(
                                  controller: _passwordController,
                                  label: 'Security Passcode',
                                  hintText: 'Enter passcode',
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
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRoutes.resetPassword);
                                    },
                                    child: const Text(
                                      'Forgot Clearance Passcode?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.industrialOrange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                CommonButton(
                                  text: 'AUTHORIZE ACCESS',
                                  isLoading: isLoading,
                                  icon: Icons.shield,
                                  onPressed: () => _onLogin(context, selectedRole),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: const [
                                    Expanded(child: Divider()),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.onSurfaceVariantText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SsoButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                          AuthLoginRequested(
                                            email: 'inspector@fireguard.org',
                                            password: 'password123',
                                            role: selectedRole,
                                            displayName: 'Lead Inspector',
                                          ),
                                        );
                                  },
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "New Inspector? ",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.onSurfaceVariantText,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, AppRoutes.signUp);
                                      },
                                      child: const Text(
                                        'Register Clearance',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.industrialOrange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

extension on TextEditingController {
  void disposeNavigator() {
    dispose();
  }
}
