package dev.sliceit.backend.service;

import java.util.UUID;

public class OrderItemDto {
    private UUID pizzaId;
    private String pizzaName, imageUrl;
    private Integer quantity;

    public UUID getPizzaId() {
        return pizzaId;
    }

    public void setPizzaId(UUID pizzaId) {
        this.pizzaId = pizzaId;
    }

    public String getPizzaName() {
        return pizzaName;
    }

    public void setPizzaName(String pizzaName) {
        this.pizzaName = pizzaName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
