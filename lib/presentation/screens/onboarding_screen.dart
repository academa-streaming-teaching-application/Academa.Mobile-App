import 'package:academa_streaming_platform/presentation/widgets/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                style: TextStyle(color: colorScheme.primary, fontSize: 36),
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
                    text: 'Comienza',
                    textColor: colorScheme.onPrimary,
                    backgroundColor: colorScheme.primary,
                    textSize: 24,
                    buttonWidth: 285,
                    buttonHeight: 65),
              )
            ],
          ),
        ),
      ),
    );
  }
}
