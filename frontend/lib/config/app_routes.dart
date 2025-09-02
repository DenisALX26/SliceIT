import 'package:frontend/pages/main_page.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/pages/sign_up.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const main = '/main';

  static final pages = {
    main:(context) => MainPage(), // needs to be const after removing test lists from main_page.dart
    login:(context) => const LoginScreen(),
    signup:(context) => const SignUpScreen(),
  };
}