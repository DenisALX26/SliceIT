package dev.sliceit.backend.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

public class CartDto {
    private UUID cartId;
    private UUID userId;
    private List<CartItemDto> items;
    private BigDecimal total;

    public UUID getCartId() {
        return cartId;
    }

    public void setCartId(UUID cartId) {
        this.cartId = cartId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public List<CartItemDto> getItems() {
        return items;
    }

    public void setItems(List<CartItemDto> items) {
        this.items = items;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }
}
