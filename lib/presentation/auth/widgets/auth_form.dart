import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/shared/custom_button.dart';
import 'labeled_fields.dart';
import 'separator.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    super.key,
    this.isSignIn = true,
    this.onTopButtonPressed,
    this.onSubmitPressed,
    this.extraFields,
  });

  final bool isSignIn;
  final VoidCallback? onTopButtonPressed;
  final VoidCallback? onSubmitPressed;
  final List<Widget>? extraFields;

  static const _paddingAll = EdgeInsets.all(24);

  static const _gap16 = SizedBox(height: 16);

  static const _gap24 = SizedBox(height: 24);

  static const _gap28 = SizedBox(height: 28);

  static const _gap42 = SizedBox(height: 42);

  static const _questionStyle = TextStyle(fontSize: 12, color: Colors.black);

  static const _actionStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  static final _boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(5)),
    boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
    ],
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final questionText =
        isSignIn ? '¿No tienes una cuenta? ' : '¿Ya tienes una cuenta? ';
    final actionText = isSignIn ? 'Regístrate' : 'Inicia sesión';
    final targetRoute = isSignIn ? '/sign-up' : '/sign-in';

    return Center(
      child: Container(
        width: screenWidth * 0.8,
        padding: _paddingAll,
        decoration: _boxDecoration.copyWith(color: colorScheme.surface),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _gap24,

            //

            CustomButton(
              text: isSignIn ? 'Continúa con Google' : 'Regístrate con Google',
              textColor: colorScheme.secondary,
              textSize: 16,
              fontWeight: FontWeight.w500,
              backgroundColor: colorScheme.onPrimary,
              buttonWidth: double.infinity,
              buttonHeight: 48,
              buttonIcon: SvgPicture.asset(
                'lib/config/assets/google_icon.svg',
                width: 24,
                height: 24,
              ),
              onPressed: onTopButtonPressed,
            ),

            _gap28,

            //

            Separator(text: 'Ingresa con', color: colorScheme.onPrimary),

            _gap16,

            //

            const LabeledField(label: 'Email', obscure: false),

            //

            const LabeledField(label: 'Password', obscure: true),

            //

            if (!isSignIn) ...[
              _gap16,
              const LabeledField(label: 'Confirma contraseña', obscure: true),
            ],

            _gap42,

            //

            CustomButton(
              text: isSignIn ? 'Inicia sesión' : 'Regístrate',
              textColor: colorScheme.onPrimary,
              textSize: 16,
              fontWeight: FontWeight.w500,
              backgroundColor: colorScheme.primary,
              buttonWidth: double.infinity,
              buttonHeight: 48,
              onPressed: onSubmitPressed,
            ),

            _gap24,

            //

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(questionText,
                    style:
                        _questionStyle.copyWith(color: colorScheme.onPrimary)),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => context.go(targetRoute),
                  child: Text(
                    actionText,
                    style: _actionStyle.copyWith(color: colorScheme.primary),
                  ),
                ),
              ],
            ),

            _gap16,
          ],
        ),
      ),
    );
  }
}
