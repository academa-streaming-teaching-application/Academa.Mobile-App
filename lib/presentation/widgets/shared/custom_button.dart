import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final double textSize;
  final Color backgroundColor;
  final double buttonWidth;
  final double buttonHeight;
  final Icon? buttonIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.textSize,
    required this.buttonWidth,
    required this.buttonHeight,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //the spread basically expands the children adding whats inside the square brackets
            if (buttonIcon != null) ...[
              buttonIcon!,
              SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
            ),
          ],
        ),
      ),
    );
  }
}
