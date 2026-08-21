import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/common_button.dart';
import 'package:fireguard_app/core/widgets/custom_text_field.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;
  final String? recoveryCode;

  const VerifyCodePage({
    super.key,
    required this.email,
    this.recoveryCode,
  });

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onVerify(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      context.read<AuthBloc>().add(
            AuthVerifyResetCode(
              email: widget.email,
              code: _codeController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.codeVerified) {
          Navigator.pushNamed(
            context,
            AppRoutes.setNewPassword,
            arguments: {
              'email': widget.email,
              'code': _codeController.text.trim(),
            },
          );
        } else if (state.status == AuthStatus.codeSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New recovery code: ${state.resetCode}'),
              backgroundColor: AppColors.successGreen,
            ),
          );
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
        final recoveryCode = state.resetCode ?? widget.recoveryCode;

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
                              border: Border.all(color: AppColors.industrialGold.withValues(alpha: 0.5)),
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: AppColors.industrialGold,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Verify Code',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurfaceText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter the 6-digit recovery code sent to ${widget.email}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariantText,
                              height: 1.4,
                            ),
                          ),
                          if (recoveryCode != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.industrialGold.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                'Development recovery code: $recoveryCode',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.industrialGold,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          CustomTextField(
                            controller: _codeController,
                            label: '6-Digit Verification Code',
                            hintText: 'Enter 6-digit code',
                            prefixIcon: Icons.pin_outlined,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || !RegExp(r'^\d{6}$').hasMatch(v.trim())) {
                                return 'Please enter a valid 6-digit code';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          CommonButton(
                            text: 'VERIFY CODE',
                            isLoading: isLoading,
                            icon: Icons.check_circle_outline,
                            onPressed: () => _onVerify(context),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive code? ",
                                style: TextStyle(
                                  color: AppColors.onSurfaceVariantText,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.read<AuthBloc>().add(AuthSendResetCode(widget.email));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Verification code resent!'),
                                      backgroundColor: AppColors.successGreen,
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Resend',
                                  style: TextStyle(
                                    color: AppColors.industrialOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
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
