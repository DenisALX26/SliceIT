package dev.sliceit.backend.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RegisterRequest(@Email @NotBlank String email, @NotBlank @Size(min = 8) String password,
        @NotBlank String fullName) {
}
