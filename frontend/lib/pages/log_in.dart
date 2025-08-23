import 'package:flutter/material.dart';
import '../colors.dart';
import '../components/round_btn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailField = TextEditingController(),
      _passwordField = TextEditingController();
  bool _isObscured = true;

  @override
  void dispose() {
    _emailField.dispose();
    _passwordField.dispose();
    super.dispose();
  }

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
                              "Log In",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 64,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Form(
                            child: Column(
                              children: [
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 64),
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: SizedBox(
                              child: RoundBtn(
                                text: "Log In",
                                bgColor: AppColors.myRed,
                                onPressed: () {
                                  // Handle login logic here
                                },
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                          // const SizedBox(height: 16,),
                          TextButton(
                            onPressed: () {
                              // Handle forgot password logic here
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),

                          // Expanded(child: Container(color: Colors.blue)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, "/signup");
                            },
                            child: Text(
                              "Sign Up",
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
