import 'package:flutter/material.dart';
import 'package:frontend/colors.dart';

class CartItem extends StatefulWidget {
  final String title, imageUrl;
  final double price;
  final int quantity;
  final VoidCallback onRemove, onIncrement, onDecrement;

  const CartItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    final isNetworkImage = widget.imageUrl.startsWith('http');
    return Container(
      padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4, right: 16),
      decoration: BoxDecoration(
        color: AppColors.inputField,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: 96,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isNetworkImage
                  ? Image.network(
                      widget.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.local_pizza, size: 32),
                    )
                  : Image.asset(widget.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '\$${widget.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_forever_outlined),
                  iconSize: 32,
                  onPressed: () {
                    widget.onRemove();
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: AppColors.myBeige,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    spacing: 4,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        iconSize: 16,
                        style: IconButton.styleFrom(
                          minimumSize: const Size(32, 32),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          widget.onDecrement();
                        },
                      ),
                      Text(
                        '${widget.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        iconSize: 16,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.myRed,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(32, 32),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          widget.onIncrement();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
