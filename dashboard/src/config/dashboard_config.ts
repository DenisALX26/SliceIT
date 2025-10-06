export const API_BASE = 'http://localhost:8080/api';

export const endpoints = {
    getOrdersForDashboard: `${API_BASE}/orders/dashboard`,
    advanceOrderStatus: (orderId: string) => `${API_BASE}/orders/${orderId}/status/advance`,
};