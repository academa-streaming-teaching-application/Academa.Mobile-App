import 'package:academa_streaming_platform/presentation/auth/widgets/sign_in_buttons.dart';
import 'package:academa_streaming_platform/presentation/auth/widgets/sign_in_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/presentation/auth/widgets/sign_in_email_form.dart';

final signInLoadingProvider = StateProvider<bool>((_) => false);

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Column(
            children: [
              SizedBox(height: 72),
              SignInHeader(),
              SizedBox(height: 48),
              SignInEmailForm(),
              SizedBox(height: 16),
              SignInButtons(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
