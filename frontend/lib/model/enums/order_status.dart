enum OrderStatus { placed, preparing, ready, completed }

extension OrderStatusExtension on OrderStatus {
  String toBackend() {
    switch (this) {
      case OrderStatus.placed:
        return "PLACED";
      case OrderStatus.preparing:
        return "PREPARING";
      case OrderStatus.ready:
        return "READY";
      case OrderStatus.completed:
        return "COMPLETED";
    }
  }

  String get label {
    switch (this) {
      case OrderStatus.placed:
        return "Placed";
      case OrderStatus.preparing:
        return "Preparing";
      case OrderStatus.ready:
        return "Ready";
      case OrderStatus.completed:
        return "Completed";
    }
  }

  static OrderStatus fromBackend(String status) {
    switch (status) {
      case "PLACED":
        return OrderStatus.placed;
      case "PREPARING":
        return OrderStatus.preparing;
      case "READY":
        return OrderStatus.ready;
      case "COMPLETED":
        return OrderStatus.completed;
      default:
        return OrderStatus.placed;
    }
  }
}
