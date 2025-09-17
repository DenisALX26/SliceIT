import 'package:flutter/material.dart';
import 'package:frontend/components/pizza_card.dart';
import 'package:frontend/controllers/cart_controller.dart';
import 'package:frontend/repository/pizza_repo.dart';
import 'package:frontend/model/pizza.dart';

class MainPage extends StatefulWidget {
  final PizzaRepo pizzaRepo;
  final CartController cartController;

  const MainPage({
    super.key,
    required this.pizzaRepo,
    required this.cartController,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _loading = true;
  List<Pizza> _pizzas = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await widget.pizzaRepo.getAllPizzas();
      setState(() {
        _pizzas = data;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
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
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 0),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _pizzas.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final pizza = _pizzas[index];
                return PizzaCard(
                  imagePath: pizza.imageUrl,
                  title: pizza.name,
                  price: pizza.price,
                  onAddToCart: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await widget.cartController.add(pizza.id);
                    } catch (e) {
                      if (mounted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                );
              },
            ),
    );
  }
}
