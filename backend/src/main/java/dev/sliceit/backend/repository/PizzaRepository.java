package dev.sliceit.backend.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import dev.sliceit.backend.model.Pizza;

public interface PizzaRepository extends JpaRepository<Pizza, UUID> {

}