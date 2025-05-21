import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../widgets/shared/custom_button.dart';
import '../provider/auth_provider.dart';
import 'labeled_fields.dart';
import 'separator.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    super.key,
    this.isSignIn = true,
    this.onSubmitSuccess,
  });

  final bool isSignIn;
  final VoidCallback? onSubmitSuccess;

  static const _gap16 = SizedBox(height: 16);
  static const _gap24 = SizedBox(height: 24);
  static const _gap28 = SizedBox(height: 28);
  static const _gap42 = SizedBox(height: 42);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final questionText =
        isSignIn ? '¿No tienes una cuenta? ' : '¿Ya tienes una cuenta? ';
    final actionText = isSignIn ? 'Regístrate' : 'Inicia sesión';
    final targetRoute = isSignIn ? '/sign-up' : '/sign-in';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _gap24,

        // Google Auth
        CustomButton(
          text: isSignIn ? 'Continúa con Google' : 'Regístrate con Google',
          textColor: colorScheme.secondary,
          backgroundColor: colorScheme.onPrimary,
          buttonWidth: double.infinity,
          buttonHeight: 48,
          textSize: 16,
          fontWeight: FontWeight.w500,
          buttonIcon: SvgPicture.asset(
            'lib/config/assets/google_icon.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () async {
            await authProvider.loginWithGoogle();
            if (authProvider.user != null) onSubmitSuccess?.call();
          },
        ),

        _gap28,

        Separator(text: 'Ingresa con', color: colorScheme.onPrimary),

        _gap16,

        // Email
        LabeledField(
          label: 'Email',
          obscure: false,
          controller: authProvider.emailController,
        ),

        // Password
        LabeledField(
          label: 'Password',
          obscure: true,
          controller: authProvider.passwordController,
        ),

        if (!isSignIn) ...[
          _gap16,
          // Confirm Password
          LabeledField(
            label: 'Confirma contraseña',
            obscure: true,
            controller: authProvider.confirmPasswordController,
          ),

          _gap16,
          // Name
          LabeledField(
            label: 'Nombre',
            controller: authProvider.nameController,
          ),
        ],

        _gap42,

        // Submit
        CustomButton(
          text: isSignIn ? 'Inicia sesión' : 'Regístrate',
          textColor: colorScheme.secondary,
          textSize: 16,
          fontWeight: FontWeight.w500,
          backgroundColor: colorScheme.onPrimary,
          buttonWidth: double.infinity,
          buttonHeight: 48,
          onPressed: () async {
            if (!isSignIn &&
                authProvider.passwordController.text !=
                    authProvider.confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Las contraseñas no coinciden')),
              );
              return;
            }

            isSignIn
                ? await authProvider.loginWithEmail()
                : await authProvider.registerWithEmail();

            if (authProvider.user != null) {
              authProvider.clearFields();
              onSubmitSuccess?.call();
            } else {
              final error = authProvider.error ?? 'Error desconocido';
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error)));
            }
          },
        ),

        _gap24,

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(questionText,
                style: TextStyle(color: colorScheme.onPrimary, fontSize: 12)),
            GestureDetector(
              onTap: () => context.go(targetRoute),
              child: Text(
                actionText,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        _gap16,
      ],
    );
  }
}
