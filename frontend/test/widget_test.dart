// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/auth/auth_state.dart';
import 'package:frontend/auth/token_store.dart';
import 'package:frontend/controllers/cart_controller.dart';
import 'package:frontend/controllers/order_controller.dart';
import 'package:frontend/repository/cart_repo.dart';
import 'package:frontend/repository/order_repo.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final userTokens = const TokenStore();
    final auth = AuthState(userTokens);
    final dio = Dio();

    final cartRepo = CartRepo(dio);
    final cartController = CartController(cartRepo);

    final orderRepo = OrderRepo(dio);
    final orderController = OrderController(orderRepo);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('Home')),
        ),
      ],
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      SliceItApp(
        router: router,
        cartController: cartController,
        authState: auth,
        orderController: orderController,
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
