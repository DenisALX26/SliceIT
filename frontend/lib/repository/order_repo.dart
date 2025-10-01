import 'package:dio/dio.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/model/order.dart';

class OrderRepo {
  final Dio _dio;
  OrderRepo(this._dio);

  Future<Order> placeOrder() async {
    try {
      final response = await _dio.post(AppConfig.orders);
      return Order.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to place order: ${e.message}');
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final response = await _dio.get(AppConfig.orders);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load orders');
    } on DioException catch (e) {
      throw Exception('Failed to load orders: ${e.message}');
    }
  }

  Future<Order> getOrderById(String orderId) async {
    try {
      final response = await _dio.get('${AppConfig.orders}/$orderId');
      return Order.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to load order: ${e.message}');
    }
  }
}
