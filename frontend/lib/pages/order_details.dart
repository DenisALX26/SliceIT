import 'package:flutter/material.dart';
import 'package:frontend/colors.dart';
import 'package:frontend/model/order_item.dart';

class OrderDetails extends StatefulWidget {
  final String orderTitle;
  final List<OrderItem> items;
  const OrderDetails({
    super.key,
    required this.orderTitle,
    required this.items,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.orderTitle),
      backgroundColor: AppColors.myBeige,),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${item.quantity} x ${item.pizzaName}',
                    style: const TextStyle(fontSize: 18)),
              ],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: widget.items.length,
        ),
      ),
    );
  }
}
