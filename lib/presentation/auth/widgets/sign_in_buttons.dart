import 'package:academa_streaming_platform/presentation/auth/provider/auth_repositoy_provider.dart';
import 'package:academa_streaming_platform/presentation/auth/provider/user_provider.dart';
import 'package:academa_streaming_platform/presentation/auth/views/sign_in_view_rebrand.dart';
import 'package:academa_streaming_platform/presentation/auth/widgets/separator.dart';
import 'package:academa_streaming_platform/presentation/shared/widgets/progress_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SignInButtons extends ConsumerWidget {
  const SignInButtons({super.key});

  Future<void> _handle(
    WidgetRef ref,
    BuildContext context, {
    required bool apple,
  }) async {
    ref.read(signInLoadingProvider.notifier).state = true;
    showProgressSnack(
      context,
      message: 'Iniciando sesión...',
      duration: const Duration(seconds: 30),
    );
    try {
      final repo = ref.read(authRepositoryProvider);
      final session = apple
          ? await repo.loginWithApple(role: 'student')
          : await repo.loginWithGoogle(role: 'student');

      await ref
          .read(authTokensProvider.notifier)
          .set(session.accessToken, session.refreshToken);

      ref.invalidate(currentUserProvider);

      if (context.mounted) {
        hideSnack(context);
        // showSuccessSnack(context, '¡Bienvenido!');
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        hideSnack(context);
        showErrorSnack(context, 'Error con ${apple ? 'Apple' : 'Google'}: $e');
      }
    } finally {
      ref.read(signInLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(signInLoadingProvider);

    return Column(
      children: [
        const Separator(text: 'Ingresa con', color: Color(0xff939398)),
        const SizedBox(height: 16),

        // Apple
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                loading ? null : () => _handle(ref, context, apple: true),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xff1D1D1E)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('lib/config/assets/apple_icon.svg',
                    width: 24, height: 24),
                const SizedBox(width: 16),
                const Text('Continúa con Apple',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Google
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                loading ? null : () => _handle(ref, context, apple: false),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xff1D1D1E)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('lib/config/assets/google_icon.svg',
                    width: 24, height: 24),
                const SizedBox(width: 16),
                const Text('Continúa con Google',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
