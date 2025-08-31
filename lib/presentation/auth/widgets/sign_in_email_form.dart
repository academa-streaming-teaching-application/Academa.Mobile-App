import 'package:academa_streaming_platform/presentation/auth/provider/auth_repositoy_provider.dart';
import 'package:academa_streaming_platform/presentation/auth/provider/user_provider.dart';
import 'package:academa_streaming_platform/presentation/auth/views/sign_in_view_rebrand.dart';
import 'package:academa_streaming_platform/presentation/shared/widgets/progress_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInEmailForm extends ConsumerStatefulWidget {
  const SignInEmailForm({super.key});

  @override
  ConsumerState<SignInEmailForm> createState() => _SignInEmailFormState();
}

class _SignInEmailFormState extends ConsumerState<SignInEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  static const Color kBorder = Color(0xff939398);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint) {
    final base = OutlineInputBorder(
      borderSide: const BorderSide(color: kBorder),
      borderRadius: BorderRadius.circular(16),
    );
    final error = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(16),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: kBorder),
      enabledBorder: base,
      focusedBorder: base,
      errorBorder: error, // mismo estilo, borde rojo
      focusedErrorBorder: error,
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
    );
  }

  String? _validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Ingresa tu email';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
    if (!ok) return 'Email inválido';
    return null;
  }

  String? _validatePass(String? v) {
    final s = (v ?? '');
    if (s.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(signInLoadingProvider.notifier).state = true;
    showProgressSnack(
      context,
      message: 'Iniciando sesión...',
      duration: const Duration(seconds: 30), // opcional: más tiempo
    );
    try {
      final repo = ref.read(authRepositoryProvider);
      final session = await repo.loginWithEmail(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );

      await ref
          .read(authTokensProvider.notifier)
          .set(session.accessToken, session.refreshToken);

      ref.invalidate(currentUserProvider);

      if (!mounted) return;
      hideSnack(context);
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      hideSnack(context);
      showErrorSnack(context, 'Error al iniciar sesión: $e');
    } finally {
      ref.read(signInLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(signInLoadingProvider);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: _emailCtrl,
            enabled: !loading,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.white,
            validator: _validateEmail,
            decoration: _decoration('Ingresa tu email'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passCtrl,
            enabled: !loading,
            obscureText: _obscure,
            cursorColor: Colors.white,
            validator: _validatePass,
            decoration: _decoration('Ingresa tu contraseña').copyWith(
              suffixIcon: IconButton(
                onPressed:
                    loading ? null : () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off,
                  color: kBorder,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: loading ? null : _loginEmail,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              child: const Text('Continúa', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: loading ? null : () {/* TODO: forgot password */},
            child: const Text('¿Olvidaste tu contraseña?',
                style: TextStyle(color: kBorder)),
          ),
        ],
      ),
    );
  }
}
