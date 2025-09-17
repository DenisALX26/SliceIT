class CartItem {
  final String cartItemId;
  final String pizzaId;
  final String pizzaName, imageUrl;
  
  final int quantity;
  final double unitPrice;

  CartItem({
    required this.cartItemId,
    required this.pizzaId,
    required this.pizzaName,
    required this.quantity,
    required this.unitPrice,
    required this.imageUrl,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'] as String,
      pizzaId: json['pizzaId'] as String,
      pizzaName: json['pizzaName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: _asDouble(json['unitPrice']),
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'cartItemId': cartItemId,
    'pizzaId': pizzaId,
    'pizzaName': pizzaName,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'imageUrl': imageUrl,
  };
}

double _asDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  throw FormatException('Cannot convert $value to double');
}
