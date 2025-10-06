import OrdersGrid from "./(components)/orders_grid";
import { fetchOrders } from "@/data/orders";

export default async function Home({
  searchParams,
}: {
  searchParams?: { status?: string };
}) {
  const status = searchParams?.status;
  const orders = await fetchOrders(status);
  return <OrdersGrid orders={orders} />;
}