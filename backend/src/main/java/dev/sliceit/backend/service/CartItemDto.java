package dev.sliceit.backend.service;

import java.math.BigDecimal;
import java.util.UUID;

public class CartItemDto {
    private final UUID cartItemId;
    private final UUID pizzaId;
    private final String pizzaName, imageUrl;
    private final int quantity;
    private final BigDecimal unitPrice;

    public CartItemDto(UUID cartItemId, UUID pizzaId, String pizzaName, int quantity, BigDecimal unitPrice, String imageUrl) {
        this.cartItemId = cartItemId;
        this.pizzaId = pizzaId;
        this.pizzaName = pizzaName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.imageUrl = imageUrl;
    }

    public UUID getCartItemId() {
        return cartItemId;
    }

    public UUID getPizzaId() {
        return pizzaId;
    }

    public String getPizzaName() {
        return pizzaName;
    }

    public int getQuantity() {
        return quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }
}
