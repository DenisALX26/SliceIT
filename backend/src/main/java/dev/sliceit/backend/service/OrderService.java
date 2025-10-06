package dev.sliceit.backend.service;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dev.sliceit.backend.model.Cart;
import dev.sliceit.backend.model.Order;
import dev.sliceit.backend.model.OrderItem;
import dev.sliceit.backend.model.User;
import dev.sliceit.backend.model.enums.OrderStatus;
import dev.sliceit.backend.repository.CartRepository;
import dev.sliceit.backend.repository.OrderRepository;
import dev.sliceit.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OrderService {
    private final UserRepository userRepository;
    private final CartRepository cartRepository;
    private final OrderRepository orderRepository;

    @Transactional
    public OrderDto placeOrder(UUID userId) {
        var user = getUser(userId);
        var cart = getCart(user);

        if (cart.getItems().isEmpty()) {
            throw new IllegalStateException("Cart is empty");
        }

        var order = Order.builder().user(user).build();

        cart.getItems().forEach(item -> {
            var orderItem = OrderItem.builder().order(order).pizza(item.getPizza()).quantity(item.getQuantity())
                    .build();
            order.getItems().add(orderItem);
        });

        var savedOrder = orderRepository.save(order);

        cart.getItems().clear();
        cartRepository.save(cart);

        return toDto(savedOrder);
    }

    @Transactional(readOnly = true)
    public List<OrderDto> getOrders(UUID userId) {
        var user = getUser(userId);
        var orders = orderRepository.findByUserOrderByCreatedAtDesc(user);
        return orders.stream().map(this::toDto).toList();
    }

    @Transactional
    public OrderDto getOrder(UUID userId, UUID orderId) {
        var user = getUser(userId);
        var order = orderRepository.findByIdAndUser(orderId, user)
                .orElseThrow(() -> new IllegalArgumentException("Order not found"));
        return toDto(order);
    }

    @Transactional(readOnly = true)
    public List<OrderDto> getAllOrdersForDashboard() {
        return orderRepository.findAll().stream().map(this::toDto).toList();
    }

    @Transactional
    public OrderDto advanceOrderStatus(UUID orderId) {
        var order = orderRepository.findById(orderId).orElseThrow(() -> new IllegalArgumentException("Order not found"));
        var currentStatus = order.getStatus();
        var nextStatus = switch (currentStatus) {
            case PLACED -> OrderStatus.PREPARING;
            case PREPARING -> OrderStatus.READY;
            case READY -> OrderStatus.COMPLETED;
            case COMPLETED -> null;
        };
        if (nextStatus == null) {
            return toDto(order);
        }
        order.setStatus(nextStatus);
        var savedOrder = orderRepository.save(order);
        return toDto(savedOrder);
    }

    private User getUser(UUID userId) {
        return userRepository.findById(userId).orElseThrow(() -> new IllegalArgumentException("User not found"));
    }

    private Cart getCart(User user) {
        return cartRepository.findByUser(user).orElseThrow(() -> new IllegalArgumentException("Cart not found"));
    }

    private OrderDto toDto(Order order) {
        var dto = new OrderDto();
        dto.setOrderId(order.getId());
        dto.setUserId(order.getUser().getId());
        dto.setStatus(order.getStatus());
        dto.setUserFullName(order.getUser().getFullName());
        dto.setCreatedAt(order.getCreatedAt());
        dto.setItems(order.getItems().stream().map(item -> {
            var itemDto = new OrderItemDto();
            itemDto.setPizzaId(item.getPizza().getId());
            itemDto.setPizzaName(item.getPizza().getName());
            itemDto.setImageUrl(item.getPizza().getImageUrl());
            itemDto.setQuantity(item.getQuantity());
            return itemDto;
        }).toList());
        return dto;
    }
}
