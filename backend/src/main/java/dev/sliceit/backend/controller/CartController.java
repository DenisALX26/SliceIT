package dev.sliceit.backend.controller;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import dev.sliceit.backend.service.CartDto;
import dev.sliceit.backend.service.CartService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {
    private final CartService cartService;

    @GetMapping
    public ResponseEntity<CartDto> getCart() {
        UUID userId = currentUserId();
        return ResponseEntity.ok(cartService.getOrCreateCart(userId));
    }

    @PostMapping("/items")
    public ResponseEntity<CartDto> addItem(@RequestBody @Valid AddItemRequest request) {
        UUID userId = currentUserId();
        var dto = cartService.addItem(userId, request.pizzaId(), request.quantity());
        return ResponseEntity.ok(dto);
    }

    @PatchMapping("/items/{pizzaId}")
    public ResponseEntity<CartDto> updateItem(@PathVariable UUID pizzaId,
            @RequestBody @Valid UpdateItemRequest request) {
        UUID userId = currentUserId();
        var dto = cartService.updateItem(userId, pizzaId, request.quantity());
        return ResponseEntity.ok(dto);
    }

    @DeleteMapping("/items/{pizzaId}")
    public ResponseEntity<CartDto> removeItem(@PathVariable UUID pizzaId) {
        UUID userId = currentUserId();
        var dto = cartService.removeItem(userId, pizzaId);
        return ResponseEntity.ok(dto);
    }

    @DeleteMapping
    public ResponseEntity<Void> clear() {
        UUID userId = currentUserId();
        cartService.clearCart(userId);
        return ResponseEntity.noContent().build();
    }

    private UUID currentUserId() {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getPrincipal() == null) {
            throw new IllegalStateException("User not authenticated");
        }
        return UUID.fromString(auth.getPrincipal().toString());
    }
}
