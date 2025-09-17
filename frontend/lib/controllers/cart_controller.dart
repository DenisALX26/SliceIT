import 'package:flutter/foundation.dart';
import 'package:frontend/model/cart.dart';
import 'package:frontend/repository/cart_repo.dart';

class CartController extends ChangeNotifier {
  final CartRepo _cartRepo;
  CartController(this._cartRepo);

  Cart? _cart;
  String? _error;
  bool _isLoading = false;

  Cart? get cart => _cart;
  String? get error => _error;
  bool get isLoading => _isLoading;

  int get itemCount {
    if (_cart == null) return 0;
    return _cart!.items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _cart?.total ?? 0.0;
  }

  Future<void> loadCart() async {
    _error = null;
    _isLoading = true;
    notifyListeners();
    try {
      _cart = await _cartRepo.getCart();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(String pizzaId, {int quantity = 1}) async {
    _error = null;
    try {
      _cart = await _cartRepo.addItemToCart(
        pizzaId: pizzaId,
        quantity: quantity,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> setQuantity(String pizzaId, int quantity) async {
    _error = null;
    try {
      _cart = await _cartRepo.setQuantity(pizzaId: pizzaId, quantity: quantity);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> remove(String pizzaId) async {
    _error = null;
    try {
      _cart = await _cartRepo.removeItemFromCart(pizzaId: pizzaId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> clear() async {
    _error = null;
    try {
      await _cartRepo.clearCart();
      _cart = _cart == null
          ? null
          : Cart(
              cartId: _cart!.cartId,
              userId: _cart!.userId,
              items: [],
              total: 0.0,
            );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
