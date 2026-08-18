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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUp(BuildContext context, String role) {
    if (_formKey.currentState?.validate() == true) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: AppColors.safetyRed,
          ),
        );
        return;
      }
      context.read<AuthBloc>().add(
            AuthSignUpRequested(
              fullName: _fullNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              role: role,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.industrialOrange.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Image.network(
                                  AssetPaths.logoUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.badge,
                                    color: AppColors.industrialOrange,
                                    size: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Officer Registration',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurfaceText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Create your NFPA / EHS Safety Clearance ID',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariantText,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _fullNameController,
                                  label: 'Full Name / Officer Title',
                                  hintText: 'e.g. Alex Rivera',
                                  prefixIcon: Icons.person_outline,
                                  validator: (v) => Validators.validateNotEmpty(v, 'Full Name'),
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _emailController,
                                  label: 'Official Email ID',
                                  hintText: 'inspector@fireguard.org',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.validateEmail,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _passwordController,
                                  label: 'Security Passcode',
                                  hintText: 'Min 6 characters',
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
                                  label: 'Confirm Passcode',
                                  hintText: 'Repeat passcode',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: _obscurePassword,
                                  validator: (v) => Validators.validateNotEmpty(v, 'Confirm Password'),
                                ),
                                const SizedBox(height: 24),
                                CommonButton(
                                  text: 'CREATE CLEARANCE ACCOUNT',
                                  isLoading: isLoading,
                                  icon: Icons.person_add,
                                  onPressed: () => _onSignUp(context, selectedRole),
                                ),
                                const SizedBox(height: 16),
                                SsoButton(
                                  text: 'REGISTER WITH GOOGLE SSO',
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                          AuthSignUpRequested(
                                            fullName: 'Alex Rivera',
                                            email: 'inspector@fireguard.org',
                                            password: 'password123',
                                            role: selectedRole,
                                          ),
                                        );
                                  },
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Already have Clearance ID? ",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.onSurfaceVariantText,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: const Text(
                                        'Sign In',
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
