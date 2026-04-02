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
import 'package:provider/provider.dart';
import 'colors.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/repository/auth_repo.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = AppConfig.stripePublishableKey;

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

  await Stripe.instance.applySettings();

  runApp(
    SliceItApp(
      router: router,
      cartController: cartController,
      authState: auth,
      orderController: orderController,
    ),
  );
}

class SliceItApp extends StatelessWidget {
  const SliceItApp({
    super.key,
    required this.router,
    required this.cartController,
    required this.authState,
    required this.orderController,
  });

  final GoRouter router;
  final CartController cartController;
  final AuthState authState;
  final OrderController orderController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>.value(value: authState),
        ChangeNotifierProvider<CartController>.value(value: cartController),
        ChangeNotifierProvider<OrderController>.value(value: orderController),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.myBeige,
          useMaterial3: true,
          fontFamily: AppStrings.fontFamily,
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
