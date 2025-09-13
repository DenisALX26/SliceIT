package dev.sliceit.backend.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import dev.sliceit.backend.model.Cart;
import dev.sliceit.backend.model.CartItem;
import dev.sliceit.backend.model.Pizza;

public interface CartItemRepository extends JpaRepository<CartItem, UUID> {
    List<CartItem> findByCart(Cart cart);
    void deleteByCart(Cart cart);
    Optional<CartItem> findByCartAndPizza(Cart cart, Pizza pizza);
}
