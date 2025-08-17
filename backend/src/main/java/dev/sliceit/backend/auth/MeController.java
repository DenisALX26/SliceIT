package dev.sliceit.backend.auth;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import dev.sliceit.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/me")
@RequiredArgsConstructor
public class MeController {

    private final UserRepository userRepository;

    @GetMapping
    public Map<String, Object> me(Authentication auth) {
        var userId = UUID.fromString(auth.getName());
        var user = userRepository.findById(userId).orElseThrow();

        return Map.of(
                "id", user.getId(),
                "email", user.getEmail(),
                "fullName", user.getFullName()
        );
    }
}
