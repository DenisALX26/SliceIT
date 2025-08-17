package dev.sliceit.backend.user;

import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.context.ActiveProfiles;

import dev.sliceit.backend.model.User;
import dev.sliceit.backend.repository.UserRepository;
import dev.sliceit.backend.security.JwtService;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class MeEndpointTest {
    @Autowired
    MockMvc mockMvc;
    @Autowired
    UserRepository userRepository;
    @Autowired
    PasswordEncoder passwordEncoder;
    @Autowired
    JwtService jwtService;

    private User user;
    private String token;

    @BeforeEach
    void setup() {
        userRepository.deleteAll();

        user = User.builder()
                .email("tester@slice.it")
                .fullName("Tester Slice")
                .passwordHash(passwordEncoder.encode("Parola123!"))
                .build();
        user = userRepository.save(user);
        token = jwtService.generate(
                user.getId().toString(),
                Map.of("email", user.getEmail(), "role", user.getUserRole().name()));
    }

    @Test
    void me_withoutToken_returns401() throws Exception {
        mockMvc.perform(get("/api/me"))
               .andExpect(status().isUnauthorized());
    }

    @Test
    void me_withValidToken_returns200_andUserId() throws Exception {
        mockMvc.perform(get("/api/me")
                .header("Authorization", "Bearer " + token))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$.userId").value(user.getId().toString()));
    }
}
