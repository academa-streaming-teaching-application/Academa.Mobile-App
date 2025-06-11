// auth_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/shared/custom_button.dart';
import '../provider/auth_provider.dart';
import '../../widgets/shared/labeled_fields.dart';
import 'separator.dart';

class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({super.key, this.isSignIn = true});
  final bool isSignIn;

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  final _name = TextEditingController();
  final _lastName = TextEditingController();
  String _role = 'teacher';

  /*-------------------- estilos/const ---------------------*/
  static const _gap16 = SizedBox(height: 16);
  static const _gap24 = SizedBox(height: 24);
  static const _gap28 = SizedBox(height: 28);
  static const _gap42 = SizedBox(height: 42);
  static const _questionStyle = TextStyle(fontSize: 12, color: Colors.black);
  static const _actionStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  static final _boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(5)),
    border: Border.all(color: Colors.white),
    boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
    ],
  );

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final notifier = ref.read(authProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final screenW = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenW * 0.8,
        padding: const EdgeInsets.all(24),
        decoration: _boxDecoration.copyWith(color: colors.surface),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _gap24,
            CustomButton(
              text: widget.isSignIn
                  ? 'Continúa con Google'
                  : 'Regístrate con Google',
              textColor: colors.secondary,
              textSize: 16,
              fontWeight: FontWeight.w500,
              backgroundColor: colors.onPrimary,
              buttonWidth: double.infinity,
              buttonHeight: 48,
              buttonIcon: SvgPicture.asset(
                'lib/config/assets/google_icon.svg',
                width: 24,
                height: 24,
              ),
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      await notifier.loginWithGoogle(_role);
                      if (ref.read(authProvider).user != null) context.go('/');
                    },
            ),
            _gap28,
            Separator(text: 'Ingresa con', color: colors.onPrimary),
            _gap16,
            if (auth.isLoading) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              )
            ] else ...[
              LabeledField(label: 'Email', controller: _email),
              _gap16,
              LabeledField(label: 'Password', controller: _pass, obscure: true),
              if (!widget.isSignIn) ...[
                _gap16,
                LabeledField(
                  label: 'Confirma contraseña',
                  controller: _confirm,
                  obscure: true,
                ),
                _gap16,
              ],
              _gap42,
              CustomButton(
                text: widget.isSignIn ? 'Inicia sesión' : 'Regístrate',
                textColor: colors.secondary,
                textSize: 16,
                fontWeight: FontWeight.w500,
                backgroundColor: colors.onPrimary,
                buttonWidth: double.infinity,
                buttonHeight: 48,
                onPressed: () async {
                  if (!_validateForm(context)) return;

                  if (widget.isSignIn) {
                    await notifier.loginWithEmail(
                      email: _email.text.trim(),
                      password: _pass.text,
                    );
                  } else {
                    await notifier.registerWithEmail(
                      email: _email.text.trim(),
                      password: _pass.text,
                      name: _name.text,
                      lastName: _lastName.text,
                      role: _role,
                    );
                  }
                  if (!mounted) return;

                  if (ref.read(authProvider).user != null) {
                    context.go('/');
                  }
                },
              ),
              if (auth.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    auth.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
            _gap24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isSignIn
                      ? '¿No tienes una cuenta? '
                      : '¿Ya tienes una cuenta? ',
                  style: _questionStyle.copyWith(color: colors.onPrimary),
                ),
                GestureDetector(
                  onTap: () =>
                      context.go(widget.isSignIn ? '/sign-up' : '/sign-in'),
                  child: Text(
                    widget.isSignIn ? 'Regístrate' : 'Inicia sesión',
                    style: _actionStyle.copyWith(color: colors.primary),
                  ),
                ),
              ],
            ),
            _gap16,
          ],
        ),
      ),
    );
  }

  bool _validateForm(BuildContext ctx) {
    final email = _email.text.trim();
    if (email.isEmpty || _pass.text.isEmpty) {
      _showError(ctx, 'Email y contraseña son obligatorios.');
      return false;
    }
    if (!widget.isSignIn && _pass.text != _confirm.text) {
      _showError(ctx, 'Las contraseñas no coinciden.');
      return false;
    }
    return true;
  }

  void _showError(BuildContext ctx, String msg) => ScaffoldMessenger.of(ctx)
      .showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
}
