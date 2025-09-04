import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_state.dart';
import 'package:frontend/config/app_router.dart';
import 'package:frontend/repository/auth_repo.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/config/app_strings.dart';

class LoginController {
  final AuthRepo authRepo;
  final AuthState auth;
  final BuildContext context;

  LoginController({required this.authRepo, required this.auth, required this.context});

  Future<void> submitLogin(String email, String password) async {
    try {
      final token = await authRepo.login(email: email, password: password);
      await auth.setLoggedIn(token);
      if (context.mounted) {
        context.go(AppRoutes.main);
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.loginError)));
      }
    }
  }
}
