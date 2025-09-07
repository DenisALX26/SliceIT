import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_state.dart';
import 'package:frontend/components/custom_nav_bar.dart';
import 'package:frontend/repository/auth_repo.dart';
import 'package:frontend/repository/pizza_repo.dart';
import 'main_page.dart';
import 'profile_page.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/colors.dart';

class RootPage extends StatefulWidget {
  final PizzaRepo pizzaRepo;
  final AuthRepo authRepo;
  final AuthState auth;
  // final int cartItemCount;
  const RootPage({super.key, required this.pizzaRepo, required this.authRepo, required this.auth});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0, _cartItemCount = 0;

  late List<Widget> _pages;

  final List<String> _pageTitles = [AppStrings.ourProducts, AppStrings.account];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _incrementCart() {
    setState(() {
      _cartItemCount++;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      MainPage(pizzaRepo: widget.pizzaRepo, onAddToCart: _incrementCart),
      ProfilePage(authRepo: widget.authRepo, auth: widget.auth),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 32,
        title: Text(
          _pageTitles[_selectedIndex],
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.myBeige,
        actionsPadding: const EdgeInsets.only(right: 32),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
              if (_cartItemCount > 0)
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
                        _cartItemCount > 99 ? '99+' : '$_cartItemCount',
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
