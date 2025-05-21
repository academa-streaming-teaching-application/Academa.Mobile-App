import 'package:academa_streaming_platform/presentation/auth/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  static const _headerStyle =
      TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black);
  static const _subtitleStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);

  static const _backgroundDecoration = BoxDecoration(
    image: DecorationImage(
      scale: 0.5,
      image: AssetImage('lib/config/assets/sign_in_up_background.png'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _backgroundDecoration,
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Inicia sesión en\ntu cuenta',
                textAlign: TextAlign.center,
                style: _headerStyle,
              ),

              //

              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.01),
                child: const Text(
                  'Ingresa tu correo y contraseña para iniciar sesión',
                  textAlign: TextAlign.center,
                  style: _subtitleStyle,
                ),
              ),

              //

              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.05),
                child: AuthForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
