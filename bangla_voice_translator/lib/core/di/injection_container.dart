import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../data/datasources/local/local_storage_source.dart';
import '../../data/datasources/remote/firebase_remote_source.dart';
import '../../data/datasources/remote/openai_remote_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/translation_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/translation_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/favorites_usecases.dart';
import '../../domain/usecases/generate_speech.dart';
import '../../domain/usecases/history_usecases.dart';
import '../../domain/usecases/transcribe_audio.dart';
import '../../domain/usecases/translate_text.dart';
import '../../domain/usecases/translate_voice.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/conversation/conversation_bloc.dart';
import '../../presentation/blocs/favorites/favorites_bloc.dart';
import '../../presentation/blocs/history/history_bloc.dart';
import '../../presentation/blocs/settings/settings_bloc.dart';
import '../../presentation/blocs/translation/translation_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Core
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocalStorageSource>(
    () => LocalStorageSourceImpl(prefs: sl()),
  );
  sl.registerLazySingleton<OpenAiRemoteSource>(
    () => OpenAiRemoteSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<FirebaseRemoteSource>(
    () => FirebaseRemoteSourceImpl(auth: sl(), firestore: sl()),
  );

  // Repositories
  sl.registerLazySingleton<TranslationRepository>(
    () => TranslationRepositoryImpl(
      remoteSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteSource: sl()),
  );
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      localSource: sl(),
      remoteSource: sl(),
    ),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      localSource: sl(),
      remoteSource: sl(),
    ),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => TranslateVoice(sl()));
  sl.registerLazySingleton(() => TranscribeAudio(sl()));
  sl.registerLazySingleton(() => TranslateText(sl()));
  sl.registerLazySingleton(() => GenerateSpeech(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInAsGuest(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => GetHistory(sl()));
  sl.registerLazySingleton(() => SaveTranslation(sl()));
  sl.registerLazySingleton(() => DeleteTranslation(sl()));
  sl.registerLazySingleton(() => ClearHistory(sl()));
  sl.registerLazySingleton(() => SearchHistory(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddFavorite(sl()));
  sl.registerLazySingleton(() => RemoveFavorite(sl()));
  sl.registerLazySingleton(() => IsFavorite(sl()));

  // BLoCs
  sl.registerFactory(
    () => TranslationBloc(
      translateVoice: sl(),
      saveTranslation: sl(),
    ),
  );
  sl.registerFactory(
    () => AuthBloc(
      signInWithEmail: sl(),
      signUpWithEmail: sl(),
      signInWithGoogle: sl(),
      signInAsGuest: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      resetPassword: sl(),
    ),
  );
  sl.registerFactory(
    () => HistoryBloc(
      getHistory: sl(),
      deleteTranslation: sl(),
      clearHistory: sl(),
      searchHistory: sl(),
    ),
  );
  sl.registerFactory(
    () => FavoritesBloc(
      getFavorites: sl(),
      addFavorite: sl(),
      removeFavorite: sl(),
    ),
  );
  sl.registerFactory(
    () => SettingsBloc(settingsRepository: sl()),
  );
  sl.registerFactory(
    () => ConversationBloc(
      transcribeAudio: sl(),
      translateText: sl(),
      generateSpeech: sl(),
    ),
  );
}
