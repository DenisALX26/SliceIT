import OrdersGrid from "./(components)/orders_grid";
import { type Order } from "./(components)/order_card";

const sampleOrders: Order[] = [
  {
    placedAt: "2023-10-01 12:00",
    customerName: "Alice",
    items: [
      { quantity: 2, name: "Pizza" },
      { quantity: 1, name: "Salad" },
    ],
    status: "placed",
  },
  {
    placedAt: "2023-10-01 12:30",
    customerName: "Bob",
    items: [
      { quantity: 1, name: "Burger" },
      { quantity: 3, name: "Fries" },
    ],
    status: "preparing",
  },
  {
    placedAt: "2023-10-01 13:00",
    customerName: "Charlie",
    items: [
      { quantity: 1, name: "Pasta" },
      { quantity: 2, name: "Garlic Bread" },
    ],
    status: "ready",
  },
];

export default function Home() {
  return <OrdersGrid orders={sampleOrders} />;
}