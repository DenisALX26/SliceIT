import 'package:dio/dio.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/model/cart.dart';

class CartRepo {
  final Dio _dio;
  CartRepo(this._dio);

  Future<Cart> getCart() async {
    try {
      final response = await _dio.get(AppConfig.cart);
      return Cart.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load cart: $e');
    }
  }

  Future<Cart> addItemToCart({
    required String pizzaId,
    int quantity = 1,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.items,
        data: {
          AppStrings.pizzaIdForData: pizzaId,
          AppStrings.quantityForData: quantity,
        },
      );
      return Cart.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to add item to cart: ${e.message}');
    }
  }

  Future<Cart> setQuantity({
    required String pizzaId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.patch(
        '${AppConfig.items}/$pizzaId',
        data: {AppStrings.quantityForData: quantity},
      );
      return Cart.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to set item quantity: ${e.message}');
    }
  }

  Future<Cart> removeItemFromCart({required String pizzaId}) async {
    try {
      final response = await _dio.delete('${AppConfig.items}/$pizzaId');
      return Cart.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to remove item from cart: ${e.message}');
    }
  }

  Future<void> clearCart() async {
    try {
      await _dio.delete(AppConfig.cart);
    } on DioException catch (e) {
      throw Exception('Failed to clear cart: ${e.message}');
    }
  }
}
