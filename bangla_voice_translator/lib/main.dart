import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/conversation/conversation_bloc.dart';
import 'presentation/blocs/favorites/favorites_bloc.dart';
import 'presentation/blocs/history/history_bloc.dart';
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/settings/settings_event.dart';
import 'presentation/blocs/settings/settings_state.dart';
import 'presentation/blocs/translation/translation_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const BanglaVoiceTranslatorApp());
}

class BanglaVoiceTranslatorApp extends StatelessWidget {
  const BanglaVoiceTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              di.sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider(create: (_) => di.sl<TranslationBloc>()),
        BlocProvider(create: (_) => di.sl<HistoryBloc>()),
        BlocProvider(create: (_) => di.sl<FavoritesBloc>()),
        BlocProvider(
          create: (_) =>
              di.sl<SettingsBloc>()..add(const LoadSettings()),
        ),
        BlocProvider(create: (_) => di.sl<ConversationBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            title: 'Bangla Voice Translator',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.themeMode,
            routerConfig: AppRouter.router,
            locale: settingsState.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('bn'),
              Locale('ko'),
            ],
          );
        },
      ),
    );
  }
}
