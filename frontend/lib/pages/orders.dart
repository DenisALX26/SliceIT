import 'package:flutter/material.dart';
import 'package:frontend/colors.dart';
import 'package:frontend/components/order_history_section.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/model/enums/order_status.dart';
import 'package:frontend/model/order.dart';
import 'package:frontend/repository/order_repo.dart';

class MyOrders extends StatefulWidget {
  final OrderRepo orderRepo;
  const MyOrders({super.key, required this.orderRepo});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  bool _loading = true;

  List<Order> userPlacedOrders = [];
  List<Order> userPreparingOrders = [];
  List<Order> userReadyOrders = [];
  List<Order> userCompletedOrders = [];

  Map<OrderStatus, List<Order>> ordersByStatus = {};

  static const List<OrderStatus> orderStatuses = <OrderStatus>[
    OrderStatus.ready,
    OrderStatus.preparing,
    OrderStatus.placed,
    OrderStatus.completed,
  ];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await widget.orderRepo.getOrders();
      setState(() {
        userReadyOrders = data
            .where((order) => order.status == OrderStatus.ready)
            .toList();
        userPreparingOrders = data
            .where((order) => order.status == OrderStatus.preparing)
            .toList();
        userPlacedOrders = data
            .where((order) => order.status == OrderStatus.placed)
            .toList();
        userCompletedOrders = data
            .where((order) => order.status == OrderStatus.completed)
            .toList();

        ordersByStatus = {
          OrderStatus.ready: userReadyOrders,
          OrderStatus.placed: userPlacedOrders,
          OrderStatus.preparing: userPreparingOrders,
          OrderStatus.completed: userCompletedOrders,
        };
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final statuses = OrderStatus.values;
    final nonEmptyStatuses = orderStatuses
        .where((s) => (ordersByStatus[s]?.isNotEmpty ?? false))
        .toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 32,
        title: const Text(
          AppStrings.myOrders,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.myBeige,
        actionsPadding: const EdgeInsets.only(right: 32),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: nonEmptyStatuses.isEmpty
                  ? const Center(child: Text(AppStrings.noOrdersFound))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < nonEmptyStatuses.length; i++) ...[
                          OrderSection(
                            title: nonEmptyStatuses[i].label,
                            orders: ordersByStatus[nonEmptyStatuses[i]]!,
                          ),
                          if (i != nonEmptyStatuses.length - 1)
                            const SizedBox(height: 16),
                        ],
                      ],
                    ),
            ),
    );
  }
}
