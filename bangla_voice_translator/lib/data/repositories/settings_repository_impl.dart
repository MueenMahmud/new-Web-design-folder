import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/typedef.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/local_storage_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final LocalStorageSource localSource;

  SettingsRepositoryImpl({required this.localSource});

  @override
  ResultFuture<ThemeMode> getThemeMode() async {
    try {
      final value = await localSource.getString(AppConstants.themeKey);
      switch (value) {
        case 'dark':
          return (data: ThemeMode.dark, failure: null);
        case 'light':
          return (data: ThemeMode.light, failure: null);
        default:
          return (data: ThemeMode.system, failure: null);
      }
    } catch (e) {
      return (data: ThemeMode.system, failure: null);
    }
  }

  @override
  ResultFuture<void> setThemeMode(ThemeMode mode) async {
    try {
      final value = switch (mode) {
        ThemeMode.dark => 'dark',
        ThemeMode.light => 'light',
        _ => 'system',
      };
      await localSource.setString(AppConstants.themeKey, value);
      return (data: null, failure: null);
    } catch (e) {
      return (
        data: null,
        failure: CacheFailure(message: 'Failed to save theme: $e')
      );
    }
  }

  @override
  ResultFuture<Locale> getLocale() async {
    try {
      final value = await localSource.getString(AppConstants.localeKey);
      if (value != null) {
        return (data: Locale(value), failure: null);
      }
      return (data: const Locale('en'), failure: null);
    } catch (e) {
      return (data: const Locale('en'), failure: null);
    }
  }

  @override
  ResultFuture<void> setLocale(Locale locale) async {
    try {
      await localSource.setString(
          AppConstants.localeKey, locale.languageCode);
      return (data: null, failure: null);
    } catch (e) {
      return (
        data: null,
        failure: CacheFailure(message: 'Failed to save locale: $e')
      );
    }
  }

  @override
  ResultFuture<bool> isOnboardingCompleted() async {
    try {
      final value = await localSource.getBool(AppConstants.onboardingKey);
      return (data: value ?? false, failure: null);
    } catch (e) {
      return (data: false, failure: null);
    }
  }

  @override
  ResultFuture<void> setOnboardingCompleted() async {
    try {
      await localSource.setBool(AppConstants.onboardingKey, true);
      return (data: null, failure: null);
    } catch (e) {
      return (
        data: null,
        failure: CacheFailure(message: 'Failed to save onboarding: $e')
      );
    }
  }

  @override
  ResultFuture<bool> isGuestMode() async {
    try {
      final value = await localSource.getBool(AppConstants.guestModeKey);
      return (data: value ?? false, failure: null);
    } catch (e) {
      return (data: false, failure: null);
    }
  }

  @override
  ResultFuture<void> setGuestMode(bool isGuest) async {
    try {
      await localSource.setBool(AppConstants.guestModeKey, isGuest);
      return (data: null, failure: null);
    } catch (e) {
      return (
        data: null,
        failure: CacheFailure(message: 'Failed to save guest mode: $e')
      );
    }
  }
}
