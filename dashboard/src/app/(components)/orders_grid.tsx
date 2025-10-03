"use client";

import { useSearchParams } from "next/navigation";
import OrderCard, { type Order } from "./order_card";

export default function OrdersGrid({ orders }: { orders: Order[] }) {
  const sp = useSearchParams();
  const raw = (sp.get("status") ?? "all").toLowerCase();
  const allowed = new Set(["all", "placed", "preparing", "ready"]);
  const status = allowed.has(raw) ? (raw as "all" | Order["status"]) : "all";

  const filtered =
    status === "all" ? orders : orders.filter((o) => o.status === status);

  return (
    <main className="flex flex-row justify-center items-center gap-8 flex-wrap p-8">
      {filtered.map((order, idx) => (
        <OrderCard key={idx} order={order} />
      ))}
    </main>
  );
}
