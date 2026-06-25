import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({required this.settingsRepository})
      : super(const SettingsState()) {
    on<LoadSettings>(_onLoad);
    on<ChangeThemeMode>(_onChangeTheme);
    on<ChangeLocale>(_onChangeLocale);
  }

  Future<void> _onLoad(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final themeResult = await settingsRepository.getThemeMode();
    final localeResult = await settingsRepository.getLocale();

    emit(state.copyWith(
      themeMode: themeResult.data,
      locale: localeResult.data,
      isLoaded: true,
    ));
  }

  Future<void> _onChangeTheme(
    ChangeThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    await settingsRepository.setThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onChangeLocale(
    ChangeLocale event,
    Emitter<SettingsState> emit,
  ) async {
    await settingsRepository.setLocale(event.locale);
    emit(state.copyWith(locale: event.locale));
  }
}
