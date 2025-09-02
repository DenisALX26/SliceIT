import 'package:flutter/material.dart';
import 'package:frontend/config/app_routes.dart';
import 'colors.dart';

void main() {
  runApp(const SliceItApp());
}

class SliceItApp extends StatelessWidget {
  const SliceItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.myBeige,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: AppRoutes.main,
      routes: AppRoutes.pages,
    );
  }
}
