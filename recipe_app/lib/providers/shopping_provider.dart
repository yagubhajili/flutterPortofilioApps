import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/shopping_item.dart';
import '../models/meal.dart';

class ShoppingProvider extends ChangeNotifier {
  List<ShoppingItem> _shoppingList = [];
  final _uuid = const Uuid();

  List<ShoppingItem> get shoppingList => _shoppingList;

  ShoppingProvider() {
    loadShoppingList();
  }

  // Load shopping list from local storage
  Future<void> loadShoppingList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? listJson = prefs.getString('shopping_list');
      if (listJson != null) {
        final List<dynamic> decoded = json.decode(listJson);
        _shoppingList = decoded.map((item) => ShoppingItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading shopping list: $e");
    }
  }

  // Save shopping list to local storage
  Future<void> _saveShoppingList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(_shoppingList.map((item) => item.toJson()).toList());
      await prefs.setString('shopping_list', encoded);
    } catch (e) {
      debugPrint("Error saving shopping list: $e");
    }
  }

  // Add individual ingredient to the list
  void addCustomItem(String name, String measure) {
    if (name.trim().isEmpty) return;
    _shoppingList.add(ShoppingItem(
      id: _uuid.v4(),
      name: name.trim(),
      measure: measure.trim(),
      isChecked: false,
    ));
    notifyListeners();
    _saveShoppingList();
  }

  // Add all ingredients of a meal to the shopping list
  void addMealIngredients(Meal meal) {
    for (var ing in meal.ingredients) {
      // Avoid duplicate exact matches if we can
      final exists = _shoppingList.any((item) => 
        item.name.toLowerCase() == ing.ingredient.toLowerCase() && 
        item.measure.toLowerCase() == ing.measure.toLowerCase() && 
        !item.isChecked
      );
      if (!exists) {
        _shoppingList.add(ShoppingItem(
          id: _uuid.v4(),
          name: ing.ingredient,
          measure: ing.measure,
          isChecked: false,
        ));
      }
    }
    notifyListeners();
    _saveShoppingList();
  }

  // Toggle checkout status
  void toggleItemChecked(String id) {
    final index = _shoppingList.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _shoppingList[index].isChecked = !_shoppingList[index].isChecked;
      notifyListeners();
      _saveShoppingList();
    }
  }

  // Delete item from list
  void removeItem(String id) {
    _shoppingList.removeWhere((item) => item.id == id);
    notifyListeners();
    _saveShoppingList();
  }

  // Clear completed items
  void clearCompleted() {
    _shoppingList.removeWhere((item) => item.isChecked);
    notifyListeners();
    _saveShoppingList();
  }

  // Clear all items
  void clearAll() {
    _shoppingList.clear();
    notifyListeners();
    _saveShoppingList();
  }
}
