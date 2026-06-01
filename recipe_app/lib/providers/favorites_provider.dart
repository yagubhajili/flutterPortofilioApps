import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Meal> _favorites = [];

  List<Meal> get favorites => _favorites;

  FavoritesProvider() {
    loadFavorites();
  }

  // Load favorites from local storage
  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString('favorites');
      if (favoritesJson != null) {
        final List<dynamic> decoded = json.decode(favoritesJson);
        _favorites = decoded.map((item) => Meal.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }
  }

  // Save favorites to local storage
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(_favorites.map((item) => item.toJson()).toList());
      await prefs.setString('favorites', encoded);
    } catch (e) {
      debugPrint("Error saving favorites: $e");
    }
  }

  // Check if a meal is marked as favorite
  bool isFavorite(String idMeal) {
    return _favorites.any((meal) => meal.idMeal == idMeal);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Meal meal) async {
    final index = _favorites.indexWhere((item) => item.idMeal == meal.idMeal);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(meal);
    }
    notifyListeners();
    await _saveFavorites();
  }
}
