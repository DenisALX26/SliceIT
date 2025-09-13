package dev.sliceit.backend.service;

import java.math.BigDecimal;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dev.sliceit.backend.model.Cart;
import dev.sliceit.backend.model.CartItem;
import dev.sliceit.backend.model.Pizza;
import dev.sliceit.backend.model.User;
import dev.sliceit.backend.repository.CartItemRepository;
import dev.sliceit.backend.repository.CartRepository;
import dev.sliceit.backend.repository.PizzaRepository;
import dev.sliceit.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CartService {
    private final CartRepository cartRepository;
    private final CartItemRepository itemRepository;
    private final UserRepository userRepository;
    private final PizzaRepository pizzaRepository;

    @Transactional
    public CartDto getOrCreateCart(UUID userId) {
        var user = getUser(userId);
        var cart = cartRepository.findByUser(user).orElseGet(() -> {
            var newCart = Cart.builder().user(user).build();
            return cartRepository.save(newCart);
        });
        return toDto(cart);
    }

    @Transactional(readOnly = true)
    public CartDto getCart(UUID userId) {
        var user = getUser(userId);
        var cart = cartRepository.findByUser(user).orElseThrow(() -> new IllegalArgumentException("Cart not found"));
        return toDto(cart);
    }

    @Transactional
    public CartDto addItem(UUID userId, UUID pizzaId, int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero");
        }
        var user = getUser(userId);
        var pizza = getPizza(pizzaId);
        var cart = cartRepository.findByUser(user).orElseGet(() -> {
            var newCart = Cart.builder().user(user).build();
            return cartRepository.save(newCart);
        });
        var item = itemRepository.findByCartAndPizza(cart, pizza).orElse(null);
        if (item == null) {
            item = CartItem.builder().cart(cart).pizza(pizza).quantity(quantity).unitPrice(pizza.getPrice()).build();
            cart.getItems().add(item);
        } else {
            item.setQuantity(item.getQuantity() + quantity);
        }
        itemRepository.save(item);
        return toDto(cart);
    }

    @Transactional
    public CartDto updateItem(UUID userId, UUID pizzaId, int quantity) {
        if (quantity < 0) {
            throw new IllegalArgumentException("Quantity must be non-negative");
        }
        var user = getUser(userId);
        var pizza = getPizza(pizzaId);
        var cart = cartRepository.findByUser(user).orElseThrow(() -> new IllegalArgumentException("Cart not found"));
        var item = itemRepository.findByCartAndPizza(cart, pizza)
                .orElseThrow(() -> new IllegalArgumentException("Item not found in cart"));
        if (quantity == 0) {
            cart.getItems().removeIf(ci -> ci.getPizza().getId().equals(pizzaId));
        } else {
            item.setQuantity(quantity);
            itemRepository.save(item);
        }
        return toDto(cart);
    }

    @Transactional
    public CartDto removeItem(UUID userId, UUID pizzaId) {
        var user = getUser(userId);
        var cart = cartRepository.findByUser(user).orElseThrow(() -> new IllegalArgumentException("Cart not found"));
        boolean removed = cart.getItems().removeIf(item -> item.getPizza().getId().equals(pizzaId));
        if (!removed) {
            throw new IllegalArgumentException("Item not found in cart");
        }
        return toDto(cart);
    }

    @Transactional
    public void clearCart(UUID userId) {
        var user = getUser(userId);
        var cart = cartRepository.findByUser(user).orElseThrow(() -> new IllegalArgumentException("Cart not found"));
        itemRepository.deleteByCart(cart);
        cart.getItems().clear();
    }

    private User getUser(UUID userId) {
        return userRepository.findById(userId).orElseThrow(() -> new IllegalArgumentException("User not found"));
    }

    private Pizza getPizza(UUID pizzaId) {
        return pizzaRepository.findById(pizzaId).orElseThrow(() -> new IllegalArgumentException("Pizza not found"));
    }

    private BigDecimal calculateTotalPrice(Cart cart) {
        return cart.getItems().stream()
                .map(item -> item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private CartDto toDto(Cart cart) {
        var dto = new CartDto();
        dto.setCartId(cart.getId());
        dto.setUserId(cart.getUser().getId());
        dto.setItems(cart.getItems().stream().map(item -> new CartItemDto(item.getId(), item.getPizza().getId(),
                item.getPizza().getName(), item.getQuantity(), item.getUnitPrice())).toList());
        dto.setTotal(calculateTotalPrice(cart));
        return dto;
    }
}
