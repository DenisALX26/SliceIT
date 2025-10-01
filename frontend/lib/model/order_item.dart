class OrderItem {
  final String pizzaId, pizzaName, imageUrl;
  final int quantity;

  OrderItem({
    required this.pizzaId,
    required this.pizzaName,
    required this.imageUrl,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      pizzaId: json['pizzaId'] as String,
      pizzaName: json['pizzaName'] as String,
      imageUrl: json['imageUrl'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pizzaId': pizzaId,
      'pizzaName': pizzaName,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}
