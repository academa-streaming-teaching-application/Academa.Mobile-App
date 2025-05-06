import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    this.obscure = false,
  });
  static const _inputDecoration = InputDecoration(border: OutlineInputBorder());
  static const _labelStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

  final String label;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 8),
        TextFormField(
          decoration: _inputDecoration,
          obscureText: obscure,
          keyboardType:
              obscure ? TextInputType.text : TextInputType.emailAddress,
        ),
      ],
    );
  }
}
