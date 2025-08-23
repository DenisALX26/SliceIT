import 'package:flutter/material.dart';
import "../colors.dart";
import '../components/round_btn.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailField = TextEditingController();
  final _passwordField = TextEditingController();
  final _fullNameField = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
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
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _fullNameField,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.inputField,
                                    hintText: "Full Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailField,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.inputField,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordField,
                                  obscureText: _isObscured,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.inputField,
                                    hintText: "Password",
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
                                ),
                                const SizedBox(height: 64),
                                FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: SizedBox(
                                    child: RoundBtn(
                                      text: "Sign Up",
                                      bgColor: AppColors.myRed,
                                      onPressed: () {
                                        // Handle sign up logic here
                                      },
                                      textColor: Colors.white,
                                    ),
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
                          Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed('/login');
                            },
                            child: Text(
                              "Log In",
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
