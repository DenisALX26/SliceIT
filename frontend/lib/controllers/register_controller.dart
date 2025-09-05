import 'package:flutter/material.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/repository/auth_repo.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/config/app_router.dart';

class RegisterController {
  final AuthRepo authRepo;
  final BuildContext context;

  RegisterController({required this.authRepo, required this.context});

  Future<void> submitRegister(String fullNameString, String email, String password) async {
    try {
      final success = await authRepo.register(fullName: fullNameString, email: email, password: password);
      if (success) {
        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.registrationSuccessful)),
          );
          context.go(AppRoutes.login);
        }
      } else {
        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.registrationFailed)),
          );
        }
      }
    } on AuthException catch (e) {
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)), 
        );
      }
    }
    catch (_) {
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.registrationError)),
        );
      }
    }
  }

}