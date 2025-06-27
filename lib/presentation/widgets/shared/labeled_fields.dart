import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.labelColor = Colors.white,
    this.borderColor = Colors.grey,
    this.textColor = Colors.white,
    this.readOnly = false, // 🔸 NUEVO
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;

  final Color labelColor;
  final Color borderColor;
  final Color textColor;
  final bool readOnly; // 🔸

  static const TextStyle _labelBaseStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _labelBaseStyle.copyWith(color: labelColor),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: inputDecoration,
          style: TextStyle(color: textColor),
          obscureText: obscure,
          readOnly: readOnly, // 🔸 campo ahora puede ser solo lectura
          keyboardType:
              obscure ? TextInputType.text : TextInputType.emailAddress,
        ),
      ],
    );
  }
}
