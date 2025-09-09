import 'package:flutter/material.dart';
import 'package:frontend/config/app_router.dart';
import 'package:frontend/controllers/login_controller.dart';
import 'package:frontend/repository/user_repositoy.dart';
import 'package:go_router/go_router.dart';
import '../colors.dart';
import '../components/round_btn.dart';
import '../config/app_strings.dart';
import 'package:frontend/auth/auth_state.dart';
import 'package:frontend/repository/auth_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authRepo, required this.auth, required this.userRepo});

  final AuthRepo authRepo;
  final AuthState auth;
  final UserRepository userRepo;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailField = TextEditingController(),
      _passwordField = TextEditingController(),
      _formKey = GlobalKey<FormState>();
  bool _isObscured = true, _isLoading = false;

  @override
  void dispose() {
    _emailField.dispose();
    _passwordField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginController = LoginController(
      authRepo: widget.authRepo,
      auth: widget.auth,
      context: context,
      userRepo: widget.userRepo,
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
                              AppStrings.login,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 64,
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 64),
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: SizedBox(
                              child: RoundBtn(
                                text: _isLoading
                                    ? AppStrings.loggingIn
                                    : AppStrings.login,
                                bgColor: AppColors.myRed,
                                onPressed: () {
                                  if (_isLoading) return;
                                  FocusScope.of(context).unfocus();

                                  final valid =
                                      _formKey.currentState?.validate() ??
                                      false;
                                  if (!valid) return;

                                  setState(() => _isLoading = true);


                                  loginController
                                      .submitLogin(
                                        _emailField.text.trim(),
                                        _passwordField.text,
                                      )
                                      .whenComplete(() {
                                        if (mounted) {
                                          setState(() => _isLoading = false);
                                        }
                                      });
                                },
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle forgot password logic here
                            },
                            child: Text(
                              AppStrings.forgotPassword,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.noAccount,
                            style: TextStyle(color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go(AppRoutes.signup);
                            },
                            child: Text(
                              AppStrings.signup,
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
