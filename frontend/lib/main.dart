import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_state.dart';
import 'package:frontend/auth/dio_client.dart';
import 'package:frontend/auth/token_store.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/config/app_router.dart';
import 'package:frontend/controllers/cart_controller.dart';
import 'package:frontend/controllers/order_controller.dart';
import 'package:frontend/repository/cart_repo.dart';
import 'package:frontend/repository/order_repo.dart';
import 'package:frontend/repository/pizza_repo.dart';
import 'package:frontend/repository/user_repositoy.dart';
import 'package:go_router/go_router.dart';
import 'colors.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/repository/auth_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokens = const TokenStore(),
      auth = AuthState(tokens),
      dio = buildDio(AppConfig.baseUrl, tokens),
      authRepo = AuthRepo(dio),
      userRepo = UserRepository(dio),
      pizzaRepo = PizzaRepo(dio),
      cartRepo = CartRepo(dio),
      cartController = CartController(cartRepo),
      orderRepo = OrderRepo(dio),
      orderController = OrderController(orderRepo);

  await auth.checkLoginStatus();

  if (auth.getIsLoggedIn()) {
    try {
      final loggedInUser = await userRepo.getMe();
      auth.setUser(loggedInUser);
    } catch (_) {}
  }

  final router = buildRouter(
    auth: auth,
    authRepo: authRepo,
    userRepo: userRepo,
    pizzaRepo: pizzaRepo,
    cartController: cartController,
    orderRepo: orderRepo,
    orderController: orderController,
  );

  runApp(SliceItApp(router: router));
}

class SliceItApp extends StatelessWidget {
  const SliceItApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.myBeige,
        useMaterial3: true,
        fontFamily: AppStrings.fontFamily,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
