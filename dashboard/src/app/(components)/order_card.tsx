'use client';

import { updateOrderStatus } from "@/data/orders";
import { Order } from "@/model/order";
import { useState } from "react";
import { useRouter } from "next/navigation";

type ItemProps = {
  quantity: number;
  pizzaName: string;
};

const Item = ({ quantity, pizzaName }: ItemProps) => {
  return (
    <li className="text-black font-medium">
      {quantity} x {pizzaName}
    </li>
  );
};

const getHeaderColor = (status: Order["status"]): string => {
  switch (status) {
    case "PLACED":
      return "bg-[var(--color-primary)]";
    case "PREPARING":
      return "bg-[var(--color-yellow)]";
    case "READY":
      return "bg-[var(--color-green)]";
    default:
      return "bg-[var(--color-primary)]";
  }
};

export default function OrderCard({ order }: { order: Order }) {
  const headerColor = getHeaderColor(order.status);
  const router = useRouter();
  const [isUpdating, setIsUpdating] = useState(false);

  const handleUpdateStatus = async() => {
    setIsUpdating(true);
    try {
      await updateOrderStatus(order.orderId);
      router.refresh();
    } catch(error) {
      console.error(`Failed to update order status: ${error}`);
      alert("Failed to update order status");
    } finally {
      setIsUpdating(false);
    }
  }

  return (
    <div className="bg-[var(--color-background)] flex gap-8 flex-col items-center justify-center">
      <div className={`${headerColor} flex flex-col justify-center items-center gap-4 p-4 w-full`}>
        <h2 className="font-bold">{order.placedAt}</h2>
        <h3 className="font-semibold">{order.customerName}</h3>
      </div>
      <div className="bg-[var(--color-background)] px-8">
        <ul className="flex flex-col justify-center items-center gap-2">
          {order.items.map((item, index) => (
            <Item key={index} quantity={item.quantity} pizzaName={item.pizzaName} />
          ))}
        </ul>
      </div>
      <button
        type="button"
        className="bg-[var(--color-button)] text-black font-bold py-2 px-4 rounded cursor-pointer mb-4 mx-8"
        onClick={handleUpdateStatus}
        disabled={isUpdating}
      >
        {isUpdating ? "Updating..." : "Update Status"}
      </button>
    </div>
  );
}