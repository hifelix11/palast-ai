/// Settings: profile, locale, sign-out.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palast/core/constants/app_constants.dart';
import 'package:palast/features/auth/presentation/providers/auth_provider.dart';
import 'package:palast/features/settings/presentation/providers/settings_provider.dart';
import 'package:palast/shared/widgets/app_button.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              profile.maybeWhen(
                data: (p) => p?.fullName ?? p?.email ?? 'You',
                orElse: () => '...',
              ),
            ),
            subtitle: Text(
              profile.maybeWhen(
                data: (p) => p?.email ?? '',
                orElse: () => '',
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: Text(
                '${AppConstants.appName} - ${AppConstants.tagline}'),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton(
              label: 'Sign out',
              variant: AppButtonVariant.outlined,
              icon: Icons.logout,
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(),
            ),
          ),
        ],
      ),
    );
  }
}
