import 'package:flutter/material.dart';
import 'package:frontend/colors.dart';
import 'package:frontend/components/pizza_card.dart';
import 'package:frontend/config/app_strings.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key}); // needs to be const after removing test lists

  // list of pizza names for testing
  final List<String> pizzaNames = [
    "Pizza 1",
    "Pizza 2",
    "Pizza 4",
    "Pizza 3",
    "Pizza 5",
    "Pizza 6",
    "Pizza 7",
    "Pizza 8",
    "Pizza 9",
    "Pizza 10",
  ];
  final List<double> pizzaPrices = [
    10.00,
    12.00,
    14.00,
    16.00,
    18.00,
    20.00,
    22.00,
    24.00,
    26.00,
    28.00,
  ];
  final List<String> pizzaImages = [
    'temp/pizza1.png',
    'temp/pizza2.png',
    'temp/pizza4.png',
    'temp/pizza2.png',
    'temp/pizza2.png',
    'temp/pizza2.png',
    'temp/pizza2.png',
    'temp/pizza2.png',
    'temp/pizza2.png',
    'temp/pizza2.png',
  ];

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int cartItemCount = 0;

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
        child: ListView.separated(
          itemBuilder: (context, index) {
            return PizzaCard(
              imagePath: widget.pizzaImages[index],
              title: widget.pizzaNames[index],
              price: widget.pizzaPrices[index],
              onAddToCart: () {
                setState(() {
                  cartItemCount++;
                });
              },
            );
          },
          itemCount: widget.pizzaNames.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
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
