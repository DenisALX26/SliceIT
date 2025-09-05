import 'package:flutter/material.dart';
import 'package:frontend/controllers/register_controller.dart';
import 'package:frontend/repository/auth_repo.dart';
import "../colors.dart";
import '../components/round_btn.dart';
import '../config/app_strings.dart';
import '../config/app_router.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  final AuthRepo authRepo;

  const SignUpScreen({
    super.key,
    required this.authRepo,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailField = TextEditingController();
  final _passwordField = TextEditingController();
  final _fullNameField = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailField.dispose();
    _passwordField.dispose();
    _fullNameField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerController = RegisterController(
      authRepo: widget.authRepo,
      context: context,
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.signup,
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _fullNameField,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.inputField,
                                    hintText: AppStrings.fullName,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  validator: (value) {
                                    final x = value?.trim() ?? '';
                                    if (x.isEmpty) {
                                      return AppStrings.fullNameRequired;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailField,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.inputField,
                                    hintText: AppStrings.email,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    final x = value?.trim() ?? '';
                                    if (x.isEmpty) {
                                      return AppStrings.emailRequired;
                                    }
                                    if (!x.contains('@')) {
                                      return AppStrings.invalidEmail;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordField,
                                  obscureText: _isObscured,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.inputField,
                                    hintText: AppStrings.password,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscured
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscured = !_isObscured;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  validator: (value) {
                                    final x = value?.trim() ?? '';
                                    if (x.isEmpty) {
                                      return AppStrings.passwordRequired;
                                    }
                                    if (x.length < 8) {
                                      return AppStrings.passwordTooShort;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 64),
                                FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: RoundBtn(
                                    text: _isLoading
                                        ? AppStrings.signingUp
                                        : AppStrings.signup,
                                    bgColor: AppColors.myRed,
                                    onPressed: () {
                                      if (_isLoading) return;
                                      FocusScope.of(context).unfocus();
                                  
                                      final isValid =
                                          _formKey.currentState?.validate() ??
                                          false;
                                      if (!isValid) return;
                                  
                                      setState(() {
                                        _isLoading = true;
                                      });
                                  
                                      registerController
                                          .submitRegister(
                                            _fullNameField.text.trim(),
                                            _emailField.text.trim(),
                                            _passwordField.text,
                                          )
                                          .whenComplete(() {
                                            if (mounted) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          });
                                    },
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppStrings.haveAccount),
                          TextButton(
                            onPressed: () {
                              context.go(AppRoutes.login);
                            },
                            child: Text(
                              AppStrings.login,
                              style: TextStyle(
                                color: AppColors.myRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
