import 'package:get_it/get_it.dart';

import '../services/biometric_service.dart';
import '../../domain/repositories/card_repository.dart';
import '../../data/repositories/mock_card_repository.dart';
import '../../presentation/bloc/theme/theme_bloc.dart';
import '../../presentation/bloc/feed/feed_bloc.dart';

final getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> setupDependencies() async {
  // Core Services - Singleton
  getIt.registerLazySingleton<BiometricService>(() => BiometricService());

  // Repositories - Lazy Singleton
  getIt.registerLazySingleton<ICardRepository>(() => MockCardRepository());

  // BLoCs - Factory (new instance per request)
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc());
  getIt.registerFactory<FeedBloc>(
    () => FeedBloc(
      cardRepository: getIt<ICardRepository>(),
      biometricService: getIt<BiometricService>(),
    ),
  );

  // Initialize BiometricService
  await getIt<BiometricService>().initialize();
}

/// Dispose all resources
Future<void> disposeDependencies() async {
  getIt<BiometricService>().dispose();
  await getIt.reset();
}
