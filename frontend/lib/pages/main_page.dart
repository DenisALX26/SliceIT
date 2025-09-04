import 'package:flutter/material.dart';
import 'package:frontend/colors.dart';
import 'package:frontend/components/pizza_card.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/repository/pizza_repo.dart';
import 'package:frontend/model/pizza.dart';

class MainPage extends StatefulWidget {
  final PizzaRepo pizzaRepo;
  const MainPage({
    super.key,
    required this.pizzaRepo,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int cartItemCount = 0;
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.ourProducts,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.myBeige,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
              if (cartItemCount > 0)
                Positioned(
                  bottom: 1,
                  left: -1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.myRed,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 1.0,
                      ),
                      child: Text(
                        cartItemCount > 99 ? '99+' : '$cartItemCount',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: _pizzas.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final pizza = _pizzas[index];
                  return PizzaCard(
                    imagePath: pizza.imageUrl,
                    title: pizza.name,
                    price: pizza.price,
                    onAddToCart: () {
                      setState(() {
                        cartItemCount++;
                      });
                    },
                  );
                },
              ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.myBeige,
          border: Border(top: BorderSide(color: Colors.black, width: 2.0)),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.myRed,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: AppStrings.profile,
            ),
          ],
        ),
      ),
    );
  }
}
