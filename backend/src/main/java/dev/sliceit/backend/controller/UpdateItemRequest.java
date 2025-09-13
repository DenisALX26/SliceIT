package dev.sliceit.backend.controller;

import jakarta.validation.constraints.Min;

public record UpdateItemRequest(@Min(0) int quantity) {

}
