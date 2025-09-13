package dev.sliceit.backend.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import dev.sliceit.backend.model.Cart;
import dev.sliceit.backend.model.User;

public interface CartRepository extends JpaRepository<Cart, UUID> {
    boolean existsByUser(User user);
    void deleteByUser(User user);
    Optional<Cart> findByUser(User user);
}
