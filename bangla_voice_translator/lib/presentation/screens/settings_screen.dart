import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../blocs/settings/settings_bloc.dart';
import '../blocs/settings/settings_event.dart';
import '../blocs/settings/settings_state.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return ListView(
            children: [
              _buildSectionHeader(context, 'Appearance'),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Theme'),
                subtitle: Text(_getThemeName(settingsState.themeMode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context, settingsState),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: Text(_getLocaleName(settingsState.locale)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context, settingsState),
              ),
              const Divider(),
              _buildSectionHeader(context, 'Account'),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState.status == AuthStatus.authenticated) {
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(authState.user?.displayName ?? 'User'),
                          subtitle: Text(authState.user?.email ??
                              (authState.isGuest ? 'Guest User' : '')),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/profile'),
                        ),
                        ListTile(
                          leading: Icon(Icons.logout, color: colorScheme.error),
                          title: Text('Sign Out',
                              style: TextStyle(color: colorScheme.error)),
                          onTap: () {
                            context
                                .read<AuthBloc>()
                                .add(const SignOutRequested());
                            context.go('/login');
                          },
                        ),
                      ],
                    );
                  }
                  return ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Sign In'),
                    onTap: () => context.go('/login'),
                  );
                },
              ),
              const Divider(),
              _buildSectionHeader(context, 'About'),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('App Version'),
                subtitle: Text(AppConstants.appVersion),
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Privacy Policy'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.gavel),
                title: const Text('Terms of Service'),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, SettingsState state) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: state.themeMode,
              onChanged: (value) {
                context
                    .read<SettingsBloc>()
                    .add(ChangeThemeMode(themeMode: value!));
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: state.themeMode,
              onChanged: (value) {
                context
                    .read<SettingsBloc>()
                    .add(ChangeThemeMode(themeMode: value!));
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: state.themeMode,
              onChanged: (value) {
                context
                    .read<SettingsBloc>()
                    .add(ChangeThemeMode(themeMode: value!));
                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsState state) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: state.locale.languageCode,
              onChanged: (value) {
                context
                    .read<SettingsBloc>()
                    .add(ChangeLocale(locale: Locale(value!)));
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<String>(
              title: const Text('Bangla'),
              value: 'bn',
              groupValue: state.locale.languageCode,
              onChanged: (value) {
                context
                    .read<SettingsBloc>()
                    .add(ChangeLocale(locale: Locale(value!)));
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<String>(
              title: const Text('Korean'),
              value: 'ko',
              groupValue: state.locale.languageCode,
              onChanged: (value) {
                context
                    .read<SettingsBloc>()
                    .add(ChangeLocale(locale: Locale(value!)));
                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  String _getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'bn':
        return 'Bangla';
      case 'ko':
        return 'Korean';
      default:
        return 'English';
    }
  }
}
