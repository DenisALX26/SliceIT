import 'package:frontend/auth/auth_state.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/pages/root_page.dart';
import 'package:frontend/repository/pizza_repo.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/pages/sign_up.dart';
import 'package:frontend/repository/auth_repo.dart';
import 'package:dio/dio.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {AppStrings.contentType: AppStrings.applicationJson},
  ),
);

final PizzaRepo pizzaRepo = PizzaRepo(dio);

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const root = '/root';
}

GoRouter buildRouter({required AuthState auth, required AuthRepo authRepo}) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: auth,
    redirect: (context, state) {
      final loggedIn = auth.getIsLoggedIn(),
          location = state.matchedLocation,
          isLoggingIn = location == AppRoutes.login,
          isSigningUp = location == AppRoutes.signup;

      if (!loggedIn && !isLoggingIn && !isSigningUp) {
        return AppRoutes.login;
      }
      if (loggedIn && (isLoggingIn || isSigningUp)) {
        return AppRoutes.root;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            LoginScreen(authRepo: authRepo, auth: auth),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => SignUpScreen(authRepo: authRepo),
      ),
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) => RootPage(pizzaRepo: pizzaRepo),
      ),
    ],
  );
}
