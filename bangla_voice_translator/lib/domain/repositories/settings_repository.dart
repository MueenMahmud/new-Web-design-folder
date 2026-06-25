import 'package:flutter/material.dart';

import '../../core/utils/typedef.dart';

abstract class SettingsRepository {
  ResultFuture<ThemeMode> getThemeMode();

  ResultFuture<void> setThemeMode(ThemeMode mode);

  ResultFuture<Locale> getLocale();

  ResultFuture<void> setLocale(Locale locale);

  ResultFuture<bool> isOnboardingCompleted();

  ResultFuture<void> setOnboardingCompleted();

  ResultFuture<bool> isGuestMode();

  ResultFuture<void> setGuestMode(bool isGuest);
}
