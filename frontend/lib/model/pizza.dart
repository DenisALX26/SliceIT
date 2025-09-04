class Pizza {
  final String id, name, imageUrl;
  final double price;

  Pizza({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}