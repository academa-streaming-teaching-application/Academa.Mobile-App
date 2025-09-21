import 'package:flutter/material.dart';

void showProgressSnack(
  BuildContext context, {
  required String message,
  List<Widget>? actions,
  Duration duration = const Duration(seconds: 3),
  bool showCloseButton = true,
}) {
  // Acciones renderizadas dentro del contenido del SnackBar
  final actionWidgets = <Widget>[
    ...?actions,
    if (showCloseButton)
      TextButton(
        onPressed: () => hideSnack(context),
        child: const Text('Cerrar'),
      ),
  ];

  final hasActions = actionWidgets.isNotEmpty;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
            if (hasActions) const SizedBox(width: 8),
            if (hasActions)
              Wrap(spacing: 4, runSpacing: 4, children: actionWidgets),
          ],
        ),
      ),
    );
}

void hideSnack(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

void showErrorSnack(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 4)}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade700,
        duration: duration,
        content: Text(message),
      ),
    );
}

void showSuccessSnack(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 3)}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade600,
        duration: duration,
        content: Text(message),
      ),
    );
}
