import { createOrderItems, OrderItem, RawOrderItem } from "./order_item";

export type OrderStatus = "PLACED" | "PREPARING" | "READY" | "COMPLETED";

export interface RawOrder {
  orderId: string;
  userId: string;
  status: OrderStatus;
  userFullName: string;
  createdAt: string;
  items: RawOrderItem[];
}

export interface Order {
  orderId: string;
  status: OrderStatus;
  userFullName: string;
  createdAt: string;
  items: OrderItem[];
  placedAt: string;
  customerName: string;
}

export function createOrder(raw: RawOrder): Order {
  return {
    orderId: raw.orderId,
    status: raw.status,
    userFullName: raw.userFullName,
    createdAt: raw.createdAt,
    items: createOrderItems(raw.items),
    placedAt: raw.createdAt,
    customerName: raw.userFullName,
  };
}