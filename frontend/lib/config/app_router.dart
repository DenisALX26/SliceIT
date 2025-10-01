import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_state.dart';
import 'package:frontend/controllers/cart_controller.dart';
import 'package:frontend/controllers/order_controller.dart';
import 'package:frontend/pages/order_details.dart';
import 'package:frontend/pages/orders.dart';
import 'package:frontend/pages/root_page.dart';
import 'package:frontend/repository/order_repo.dart';
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
  static const orders = '/orders';
  static const orderDetails = '/order_details';
}

GoRouter buildRouter({
  required AuthState auth,
  required AuthRepo authRepo,
  required UserRepository userRepo,
  required PizzaRepo pizzaRepo,
  required CartController cartController,
  required OrderController orderController,
  required OrderRepo orderRepo,
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
        builder: (context, state) => RootPage(
          pizzaRepo: pizzaRepo,
          authRepo: authRepo,
          auth: auth,
          cartController: cartController,
        ),
      ),
      GoRoute(
        path: AppRoutes.cart,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 300),
          child: CartPage(
            cartController: cartController,
            orderController: orderController,
          ),
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
      GoRoute(
        path: AppRoutes.orders,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 300),
          child: MyOrders(
            orderRepo: orderRepo,
            // cartController: cartController,
          ),
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
      GoRoute(
        path: AppRoutes.orderDetails,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 300),
          child: OrderDetails(
            orderTitle: (state.extra as Map<String, dynamic>)['orderTitle'],
            items: (state.extra as Map<String, dynamic>)['items'],
          ),
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
