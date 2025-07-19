import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse("https://fakestoreapi.com/products"));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print('API data length: ${data.length}');
        _products = data.map<Product>((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
