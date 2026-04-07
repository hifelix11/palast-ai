/// The Palast sign-in page.
///
/// Two buttons (Google, Apple), a quiet welcome, and the tagline.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:palast/core/constants/app_constants.dart';
import 'package:palast/core/theme/design_tokens.dart';
import 'package:palast/features/auth/presentation/providers/auth_provider.dart';
import 'package:palast/shared/widgets/app_button.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PalastSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: PalastSpacing.xs),
              Text(
                AppConstants.tagline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: PalastSpacing.xxl),
              Text(
                'A quiet place for everything you find, think and want to remember.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              if (auth.hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: PalastSpacing.md),
                  child: Text(
                    'We could not sign you in. Try once more.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              AppButton(
                label: 'Continue with Google',
                icon: Icons.login,
                loading: auth.isLoading,
                onPressed: controller.signInWithGoogle,
              ),
              if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) ...[
                const SizedBox(height: PalastSpacing.sm),
                AppButton(
                  label: 'Continue with Apple',
                  variant: AppButtonVariant.outlined,
                  icon: Icons.apple,
                  loading: auth.isLoading,
                  onPressed: controller.signInWithApple,
                ),
              ],
              const SizedBox(height: PalastSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
