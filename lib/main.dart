import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/theme/theme_state.dart';
import 'presentation/bloc/feed/feed_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/bloc/reward/reward_bloc.dart';
import 'presentation/bloc/survey/survey_bloc.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Setup dependency injection
  await setupDependencies();

  runApp(const MacroMindApp());
}

class MacroMindApp extends StatelessWidget {
  const MacroMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC - manages authentication state
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthCheckRequested()),
        ),

        // Theme BLoC - manages light/dark mode
        BlocProvider<ThemeBloc>(create: (context) => getIt<ThemeBloc>()),

        // Feed BLoC - manages card feed
        BlocProvider<FeedBloc>(create: (context) => getIt<FeedBloc>()),

        // Reward BLoC - manages marketplace
        BlocProvider<RewardBloc>(create: (context) => getIt<RewardBloc>()),

        // Survey BLoC - manages surveys/taste tests
        BlocProvider<SurveyBloc>(create: (context) => getIt<SurveyBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'MacroMind',
            debugShowCheckedModeBanner: false,

            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,

            // Routing based on auth state
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthAuthenticated) {
                  return const MainShell();
                } else {
                  // Show login screen if not authenticated
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
