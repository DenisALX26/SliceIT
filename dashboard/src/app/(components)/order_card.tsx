export type OrderStatus = "placed" | "preparing" | "ready";

export type Order = {
  placedAt: string;
  customerName: string;
  items: { quantity: number; name: string }[];
  status: OrderStatus;
};

type ItemProps = {
  quantity: number;
  name: string;
};

const Item = ({ quantity, name }: ItemProps) => {
  return (
    <li className="text-black font-medium">
      {quantity} x {name}
    </li>
  );
};

export default function OrderCard({ order }: { order: Order }) {
  return (
    <div className="bg-[var(--color-background)] flex gap-8 flex-col items-center justify-center">
      <div className="bg-[var(--color-primary)] flex flex-col justify-center items-center gap-4 py-4 w-full">
        <h2 className="font-bold">{order.placedAt}</h2>
        <h3 className="font-semibold">{order.customerName}</h3>
      </div>
      <div className="bg-[var(--color-background)] px-8">
        <ul className="flex flex-col justify-center items-center gap-2">
          {order.items.map((item, index) => (
            <Item key={index} quantity={item.quantity} name={item.name} />
          ))}
        </ul>
      </div>
      <button
        type="button"
        className="bg-[var(--color-button)] text-black font-bold py-2 px-4 rounded cursor-pointer mb-4 mx-8"
      >
        Update Status
      </button>
    </div>
  );
}
