package dev.sliceit.backend.controller;

import java.util.UUID;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record AddItemRequest(@NotNull UUID pizzaId, @Min(1) int quantity) {
}
