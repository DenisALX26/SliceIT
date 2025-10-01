import 'package:flutter/material.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/model/order.dart';
import 'package:frontend/config/app_router.dart';
import 'package:go_router/go_router.dart';

class OrderSection extends StatelessWidget {
  final String title;
  final List<Order> orders;
  const OrderSection({super.key, required this.title, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (orders.isEmpty)
              const Text(AppStrings.noOrdersFound)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      context.push(AppRoutes.orderDetails, extra: {
                        'orderTitle':
                            "Order ${orders[index].createdAt.day.toString().padLeft(2, '0')}-"
                            "${orders[index].createdAt.month.toString().padLeft(2, '0')}-"
                            "${orders[index].createdAt.year} at "
                            "${orders[index].createdAt.hour.toString().padLeft(2, '0')}:"
                            "${orders[index].createdAt.minute.toString().padLeft(2, '0')}",
                        'items': orders[index].items,
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Order ${orders[index].createdAt.day.toString().padLeft(2, '0')}-"
                          "${orders[index].createdAt.month.toString().padLeft(2, '0')}-"
                          "${orders[index].createdAt.year} at "
                          "${orders[index].createdAt.hour.toString().padLeft(2, '0')}:"
                          "${orders[index].createdAt.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const Spacer(),
                        const Text(AppStrings.orderInfo, style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.underline)),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
