import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/background_grid.dart';

/// Login screen - Clean, Trustworthy Mass-Market UI
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundGrid(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppTheme.noColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final theme = Theme.of(context);

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Simple, Friendly Icon/Logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.poll_rounded,
                          size: 50,
                          color: AppTheme.primaryBlue,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Brand Identity
                      Text(
                        'MacroMind',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Insights for a better tomorrow.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Professional Auth Button
                      _GoogleSignInButton(isLoading: isLoading),

                      const SizedBox(height: 48),

                      // Privacy/Trust Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 16,
                            color: AppTheme.textDisabled,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Your data is private and secure.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final bool isLoading;

  const _GoogleSignInButton({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading
          ? null
          : () =>
                context.read<AuthBloc>().add(const SignInWithGoogleRequested()),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderLight),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.login_rounded,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
