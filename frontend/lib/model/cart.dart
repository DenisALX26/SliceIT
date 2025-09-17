import 'package:frontend/model/cart_item.dart';

class Cart {
  final String cartId;
  final String userId;
  final List<CartItem> items;
  final double total;

  Cart({
    required this.cartId,
    required this.userId,
    required this.items,
    required this.total,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cartId'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: _asDouble(json['total']),
    );
  }

  Map<String, dynamic> toJson() => {
    'cartId': cartId,
    'userId': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'total': total,
  };
}

double _asDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  throw FormatException('Cannot convert $value to double');
}
