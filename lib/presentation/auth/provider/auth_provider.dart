import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  String role = 'student';
  UserEntity? _user;
  bool _isLoading = false;
  String? _error;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loginWithEmail() async {
    _setLoading(true);
    try {
      _user = await _authRepository.loginWithEmail(
        emailController.text,
        passwordController.text,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> registerWithEmail() async {
    _setLoading(true);
    try {
      _user = await _authRepository.registerWithEmail(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        role: role,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> loginWithGoogle() async {
    _setLoading(true);
    try {
      _user = await _authRepository.loginWithGoogle(role);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
