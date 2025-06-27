import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final double textSize;
  final FontWeight fontWeight;
  final Color backgroundColor;
  final double buttonWidth;
  final double buttonHeight;
  final SvgPicture? buttonIcon;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.textSize,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.fontWeight,
    this.buttonIcon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          foregroundColor: WidgetStateProperty.all(textColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (buttonIcon != null) ...[
              buttonIcon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
