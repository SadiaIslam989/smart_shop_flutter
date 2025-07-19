import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/screens/cart_screen.dart';
import 'providers/favourites_provider.dart'; 

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'theme/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/favourites_screen.dart';


void main() {
  runApp(const SmartShopApp());
}

class SmartShopApp extends StatelessWidget {
  const SmartShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<FavouritesProvider>(create: (_) => FavouritesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Smart Shop',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getTheme(),
            home: const SplashScreen(), 
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
              '/favourites': (context) => const FavouritesScreen(),
              '/cart': (context) => const CartScreen(),
              

            },
          );
        },
      ),
    );
  }
}
