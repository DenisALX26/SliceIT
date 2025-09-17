import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_state.dart';
import 'package:frontend/controllers/cart_controller.dart';
import 'package:frontend/pages/root_page.dart';
import 'package:frontend/repository/pizza_repo.dart';
import 'package:frontend/repository/user_repositoy.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/pages/sign_up.dart';
import 'package:frontend/pages/cart.dart';
import 'package:frontend/repository/auth_repo.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const root = '/root';
  static const cart = '/cart';
}

GoRouter buildRouter({
  required AuthState auth,
  required AuthRepo authRepo,
  required UserRepository userRepo,
  required PizzaRepo pizzaRepo,
  required CartController cartController,
}) {
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
            LoginScreen(authRepo: authRepo, auth: auth, userRepo: userRepo),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => SignUpScreen(authRepo: authRepo),
      ),
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) =>
            RootPage(pizzaRepo: pizzaRepo, authRepo: authRepo, auth: auth, cartController: cartController),
      ),
      GoRoute(
        path: AppRoutes.cart,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 300),
          child: CartPage(cartController: cartController),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),
    ],
  );
}
