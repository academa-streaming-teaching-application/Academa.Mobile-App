import 'package:academa_streaming_platform/presentation/auth/widgets/auth_form.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/separator.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  static const _headerStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const _subtitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    // final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 72.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'lib/config/assets/academa_logo.svg',
                        width: 42,
                        height: 42,
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Academa',
                        // textAlign: TextAlign.center,
                        style: _headerStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Conoce tu nueva\n forma de aprender.',
                  textAlign: TextAlign.center,
                  style: _subtitleStyle,
                ),
                const SizedBox(height: 100),
                TextField(
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff939398)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff939398)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Color(0xff939398)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff939398)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff939398)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintText: 'Ingresa tu contraseña',
                    hintStyle: const TextStyle(color: Color(0xff939398)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Continúa',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      foregroundColor: WidgetStateProperty.all(Colors.black),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Separator(text: 'Ingresa con', color: Color(0xff939398)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'lib/config/assets/apple_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Continúa con Apple',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Color(0xff1D1D1E)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'lib/config/assets/google_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Continúa con Google',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Color(0xff1D1D1E)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
