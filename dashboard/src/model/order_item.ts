export interface RawOrderItem {
  pizzaId: string;
  pizzaName: string;
  imageUrl: string;
  quantity: number;
}

export interface OrderItem {
  pizzaName: string;
  quantity: number;
}

export function createOrderItems(rawItems: RawOrderItem[]): OrderItem[] {
  return rawItems.map((item) => ({
    pizzaName: item.pizzaName,
    quantity: item.quantity,
  }));
}