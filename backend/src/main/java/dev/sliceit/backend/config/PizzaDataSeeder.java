package dev.sliceit.backend.config;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import dev.sliceit.backend.model.Pizza;
import dev.sliceit.backend.repository.PizzaRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
public class PizzaDataSeeder implements CommandLineRunner {
    private final PizzaRepository pizzaRepository;

    @Override
    public void run(String... args) {
        if (pizzaRepository.count() > 0) {
            log.info("Pizza data already exists. Skipping.");
            return;
        }

        var pizzas = List.of(
                Pizza.builder()
                        .name("Margherita")
                        .price(new BigDecimal("8.99"))
                        .imageUrl("https://picsum.photos/id/0/160/160")
                        .build(),
                Pizza.builder()
                        .name("Pepperoni")
                        .price(new BigDecimal("29.90"))
                        .imageUrl("https://picsum.photos/id/1/160/160")
                        .build(),
                Pizza.builder()
                        .name("Quattro Formaggi")
                        .price(new BigDecimal("34.90"))
                        .imageUrl("https://picsum.photos/id/2/160/160")
                        .build());

        pizzaRepository.saveAll(pizzas);
        log.info("Pizza data seeded successfully.");
    }

}
