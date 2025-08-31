import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({
    super.key,
    this.logoAsset = 'lib/config/assets/academa_logo.svg',
    this.title = 'Academa',
    this.subtitle = 'Conoce tu nueva\n forma de aprender.',
  });

  final String logoAsset;
  final String title;
  final String subtitle;

  static const _headerStyle =
      TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white);
  static const _subtitleStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(logoAsset, width: 42, height: 42),
            const SizedBox(width: 16),
            Text(title, style: _headerStyle),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: _subtitleStyle,
        ),
      ],
    );
  }
}
