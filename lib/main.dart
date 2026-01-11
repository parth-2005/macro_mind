import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/theme/theme_state.dart';
import 'presentation/bloc/feed/feed_bloc.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Setup dependency injection
  await setupDependencies();

  runApp(const CrowdPulseApp());
}

class CrowdPulseApp extends StatelessWidget {
  const CrowdPulseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Theme BLoC - manages light/dark mode
        BlocProvider<ThemeBloc>(create: (context) => getIt<ThemeBloc>()),

        // Feed BLoC - manages card feed
        BlocProvider<FeedBloc>(create: (context) => getIt<FeedBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'CrowdPulse',
            debugShowCheckedModeBanner: false,

            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,

            // Home Screen
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
