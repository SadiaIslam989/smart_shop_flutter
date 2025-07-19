import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesProvider extends ChangeNotifier {
  final List<int> _favouriteIds = [];

  List<int> get favouriteIds => _favouriteIds;

  FavouritesProvider() {
    _loadFavourites();
  }

  void toggleFavourite(int productId) {
    if (_favouriteIds.contains(productId)) {
      _favouriteIds.remove(productId);
    } else {
      _favouriteIds.add(productId);
    }
    _saveFavourites();
    notifyListeners();
  }

  bool isFavourite(int productId) => _favouriteIds.contains(productId);

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favourites') ?? [];
    _favouriteIds.clear();
    _favouriteIds.addAll(favList.map(int.parse));
    notifyListeners();
  }

  Future<void> _saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favourites', _favouriteIds.map((e) => e.toString()).toList());
  }
}
