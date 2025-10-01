import 'package:flutter/foundation.dart';
import 'package:frontend/model/order.dart';
import 'package:frontend/repository/order_repo.dart';

class OrderController extends ChangeNotifier {
  final OrderRepo _orderRepo;
  OrderController(this._orderRepo);

  bool isLoading = false;
  String? error;

  List<Order> orders = [];
  Order? currentOrder;

  Future<void> loadOrders() async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      orders = await _orderRepo.getOrders();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOrderById(String orderId) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      currentOrder = await _orderRepo.getOrderById(orderId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Order> placeOrder() async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      final order = await _orderRepo.placeOrder();
      currentOrder = order;
      orders = [order, ...orders];
      return order;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
