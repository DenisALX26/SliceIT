import { endpoints } from "@/config/dashboard_config";
import { createOrder, Order, RawOrder } from "@/model/order";

export async function fetchOrders(status?: string): Promise<Order[]> {
    const url = status 
        ? `${endpoints.getOrdersForDashboard}?status=${encodeURIComponent(status)}`
        : endpoints.getOrdersForDashboard;
    
    const response = await fetch(url, { cache: 'no-store' });
    if(!response.ok) {
        throw new Error(`Failed to fetch orders: ${response.status}`);
    }
    const raw: RawOrder[] = await response.json();
    return raw.map(createOrder);
}

export async function updateOrderStatus(orderId:string) {
    try {
        const response = await fetch(endpoints.advanceOrderStatus(orderId), {
            method: 'PATCH',
        });
        if(!response.ok) {
            throw new Error('Failed to update order status');
        }
        return await response.json();
    } catch (error) {
        console.error(`Failed to update order status: ${error}`);
        throw error;
    }
}