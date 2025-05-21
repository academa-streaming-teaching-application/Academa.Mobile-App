import 'package:academa_streaming_platform/presentation/auth/widgets/auth_form.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  static const _headerStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const _subtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static const _backgroundDecoration = BoxDecoration(
    image: DecorationImage(
      scale: 0.5,
      image: AssetImage('lib/config/assets/sign_in_up_background.png'),
      fit: BoxFit.contain,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _backgroundDecoration,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: screenHeight * 0.1,
                bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                left: 16,
                right: 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: isKeyboardOpen ? 0 : constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Text(
                        'Regístrate en\nla plataforma',
                        textAlign: TextAlign.center,
                        style: _headerStyle,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ingresa tu correo y contraseña para registrarte',
                        textAlign: TextAlign.center,
                        style: _subtitleStyle,
                      ),
                      const SizedBox(height: 32),
                      const AuthForm(isSignIn: false),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
