"use client";

import { useSearchParams } from "next/navigation";
import OrderCard from "./order_card";
import { Order } from "@/model/order";

const ALLOWED = ["all", "placed", "preparing", "ready", "completed"] as const;

export default function OrdersGrid({ orders }: { orders: Order[] }) {
  const sp = useSearchParams();
  const raw = (sp.get("status") ?? "all").toLowerCase();
  const status = (ALLOWED.includes(raw as any) ? raw:"all") as | "all" | Lowercase<Order["status"]>;
  
  const filtered = orders
    .filter(o => o.status !== "COMPLETED")
    .filter(o => status === "all" || o.status.toLowerCase() === status);

  return (
    <main className="flex flex-row justify-center items-start gap-8 flex-wrap p-8">
      {filtered.map((order, idx) => (
        <OrderCard key={idx} order={order} />
      ))}
    </main>
  );
}
