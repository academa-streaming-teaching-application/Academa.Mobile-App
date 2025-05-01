import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/shared/custom_button.dart';

class LoginContainer extends StatelessWidget {
  final VoidCallback? onTopButtonPressed;
  final VoidCallback? onSubmitPressed;

  const LoginContainer({
    super.key,
    this.onTopButtonPressed,
    this.onSubmitPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: screenWidth * 0.8,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),

        //

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            CustomButton(
              text: 'Continua con Google',
              textColor: colorScheme.secondary,
              textSize: 16,
              fontWeight: FontWeight.w500,
              backgroundColor: colorScheme.onPrimary,
              buttonWidth: double.infinity,
              buttonHeight: 48,
              buttonIcon: SvgPicture.asset('lib/config/assets/google_icon.svg',
                  width: 24, height: 24),
              onPressed: onTopButtonPressed,
            ),

            //

            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                    child: Divider(color: colorScheme.onPrimary, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Ingresa con',
                      style: TextStyle(color: colorScheme.onPrimary)),
                ),
                Expanded(
                    child: Divider(color: colorScheme.onPrimary, thickness: 1)),
              ],
            ),

            //

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Email',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            //

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Password',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            //

            const SizedBox(height: 42),
            CustomButton(
              text: 'Inicia sesión',
              textColor: colorScheme.onPrimary,
              textSize: 16,
              fontWeight: FontWeight.w500,
              backgroundColor: colorScheme.primary,
              buttonWidth: double.infinity,
              buttonHeight: 48,
              onPressed: onSubmitPressed,
            ),

            //

            const SizedBox(height: 24),
            Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'No tienes una cuenta? ',
                    style:
                        TextStyle(color: colorScheme.onPrimary, fontSize: 12),
                  ),
                  TextSpan(
                    text: 'Registrate',
                    style: TextStyle(color: colorScheme.primary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
