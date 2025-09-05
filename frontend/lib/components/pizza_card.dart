import 'package:flutter/material.dart';
import 'package:frontend/colors.dart';

class PizzaCard extends StatelessWidget {
  final String imagePath, title;
  final double price;
  final VoidCallback onAddToCart;

  const PizzaCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = imagePath.startsWith('http');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputField,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: isNetworkImage
                ? Image.network(
                    imagePath,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 40),
                  )
                : Image.asset(imagePath),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              Text(
                '\$$price',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          IconButton(
            color: Colors.white,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.myRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              onAddToCart();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
