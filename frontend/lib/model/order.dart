import 'package:frontend/model/enums/order_status.dart';
import 'package:frontend/model/order_item.dart';

class Order {
  final String orderId, userId, userFullName;
  final OrderStatus status;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.userId,
    required this.userFullName,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return Order(
      orderId: json['orderId'] as String,
      userId: json['userId'] as String,
      userFullName: json['userFullName'] as String? ?? '',
      status: OrderStatusExtension.fromBackend(json['status'] as String),
      createdAt: (DateTime.parse(json['createdAt'] as String)).toLocal(),
      items: itemsJson
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "userFullName": userFullName,
      "status": status.toBackend(),
      "createdAt": createdAt.toUtc().toIso8601String(),
      "items": items.map((item) => item.toJson()).toList(),
    };
  }
}
