import 'package:flutter/material.dart';
import 'package:frontend/colors.dart';
import 'package:frontend/components/confirm_overlay.dart';
import 'package:frontend/components/round_btn.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/controllers/cart_controller.dart';
import 'package:frontend/components/cart_item.dart';
import 'package:frontend/controllers/order_controller.dart';

class CartPage extends StatefulWidget {
  final CartController cartController;
  final OrderController orderController;
  const CartPage({
    super.key,
    required this.cartController,
    required this.orderController,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _showConfirm = false, _placeOrder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 32,
        title: const Text(
          AppStrings.myCart,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.myBeige,
        actionsPadding: const EdgeInsets.only(right: 32),
        actions: [
          AnimatedBuilder(
            animation: widget.cartController,
            builder: (_, _) {
              final count = widget.cartController.itemCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {},
                  ),
                  if (count > 0)
                    Positioned(
                      bottom: 1,
                      left: -1,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.myRed,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 1.0,
                        ),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.cartController,
        builder: (ctx, _) {
          final cart = widget.cartController.cart;
          final loading = widget.cartController.isLoading;
          final items = cart?.items ?? const [];
          items.sort((a, b) => a.pizzaName.compareTo(b.pizzaName));
          final isEmpty = !loading && (items.isEmpty);

          if (loading && cart == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final content = Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                if (isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        AppStrings.emptyCart,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final it = items[i];
                        return CartItem(
                          key: ValueKey(it.pizzaId),
                          title: it.pizzaName,
                          imageUrl: it.imageUrl,
                          price: it.unitPrice * it.quantity,
                          quantity: it.quantity,
                          onRemove: () {
                            widget.cartController.remove(it.pizzaId);
                          },
                          onIncrement: () {
                            widget.cartController.setQuantity(
                              it.pizzaId,
                              it.quantity + 1,
                            );
                          },
                          onDecrement: () {
                            final next = it.quantity - 1;
                            widget.cartController.setQuantity(
                              it.pizzaId,
                              next < 0 ? 0 : next,
                            );
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                if (!isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.inputField,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          AppStrings.total,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${widget.cartController.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.myRed,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),
                if (!isEmpty)
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: RoundBtn(
                      text: AppStrings.placeOrder,
                      bgColor: AppColors.myRed,
                      onPressed: () {
                        if (_placeOrder) return;
                        setState(() {
                          _showConfirm = true;
                        });
                      },
                      textColor: Colors.white,
                    ),
                  ),
              ],
            ),
          );

          return Stack(
            children: [
              content,
              if (_showConfirm)
                ConfirmOverlay(
                  message: AppStrings.confirmOrder,
                  onNo: () {
                    setState(() {
                      _showConfirm = false;
                    });
                  },
                  onYes: () async {
                    if (_placeOrder) return;
                    setState(() {
                      _showConfirm = false;
                      _placeOrder = true;
                    });
                    try {
                      await widget.orderController.placeOrder();
                      await widget.cartController.clear();

                      if (!ctx.mounted) return;
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text(AppStrings.orderPlaced)),
                      );
                      Navigator.of(ctx).pop();
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text(AppStrings.orderFailed)),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _placeOrder = false;
                        });
                      }
                    }
                  },
                  noText: AppStrings.no,
                  yesText: AppStrings.yes,
                ),
            ],
          );
        },
      ),
    );
  }
}
