import 'package:academa_streaming_platform/presentation/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 64.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Impulsa tu\nproductividad',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: colorScheme.onPrimary),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'lib/config/assets/productivity_square.png',
                fit: BoxFit.contain,
              ),
              SizedBox(
                width: 285,
                height: 65,
                child: CustomButton(
                  fontWeight: FontWeight.bold,
                  text: 'Comienza',
                  textColor: colorScheme.secondary,
                  backgroundColor: colorScheme.onPrimary,
                  textSize: 20,
                  buttonWidth: 285,
                  buttonHeight: 65,
                  onPressed: () => {context.go('/sign-in')},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
