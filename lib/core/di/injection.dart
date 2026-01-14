import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/biometric_service.dart';
import '../../domain/repositories/card_repository.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/repositories/i_survey_repository.dart';
import '../../data/repositories/firestore_card_repository.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/repositories/firestore_survey_repository.dart';
import '../../data/repositories/firestore_reward_repository.dart';
import '../../domain/repositories/i_reward_repository.dart';
import '../../../core/services/compatibility_service.dart';
import '../../presentation/bloc/theme/theme_bloc.dart';
import '../../presentation/bloc/feed/feed_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/reward/reward_bloc.dart';
import '../../presentation/bloc/survey/survey_bloc.dart';

final getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> setupDependencies() async {
  // Core Services - Singleton
  getIt.registerLazySingleton<BiometricService>(() => BiometricService());
  getIt.registerLazySingleton<CompatibilityService>(
    () => CompatibilityService(),
  );

  // Google Sign-In (v7.x requires singleton access and initialization)
  final googleSignIn = GoogleSignIn.instance;
  await googleSignIn.initialize();

  // Firebase Auth Repository - Singleton
  getIt.registerLazySingleton<IAuthRepository>(
    () => FirebaseAuthRepository(FirebaseAuth.instance, googleSignIn),
  );

  // Firestore Card Repository - Singleton
  getIt.registerLazySingleton<ICardRepository>(
    () => FirestoreCardRepository(
      firestore: FirebaseFirestore.instance,
      authRepository: getIt<IAuthRepository>(),
    ),
  );

  // Firestore Survey Repository - Singleton
  getIt.registerLazySingleton<ISurveyRepository>(
    () => FirestoreSurveyRepository(
      firestore: FirebaseFirestore.instance,
      authRepository: getIt<IAuthRepository>(),
    ),
  );

  // Firestore Reward Repository - Singleton
  getIt.registerLazySingleton<IRewardRepository>(
    () => FirestoreRewardRepository(
      firestore: FirebaseFirestore.instance,
      authRepository: getIt<IAuthRepository>(),
    ),
  );

  // BLoCs - Factory (new instance per request)
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc());

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<IAuthRepository>()),
  );

  getIt.registerFactory<FeedBloc>(
    () => FeedBloc(
      cardRepository: getIt<ICardRepository>(),
      biometricService: getIt<BiometricService>(),
    ),
  );

  getIt.registerFactory<RewardBloc>(
    () => RewardBloc(rewardRepository: getIt<IRewardRepository>()),
  );

  getIt.registerFactory<SurveyBloc>(
    () => SurveyBloc(surveyRepository: getIt<ISurveyRepository>()),
  );

  // Initialize BiometricService
  await getIt<BiometricService>().initialize();
}

/// Dispose all resources
Future<void> disposeDependencies() async {
  getIt<BiometricService>().dispose();
  await getIt.reset();
}
