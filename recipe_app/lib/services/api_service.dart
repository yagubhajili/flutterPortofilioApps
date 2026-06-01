import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // 1. Get all meal categories
  Future<List<MealCategory>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['categories'] != null) {
        return (data['categories'] as List)
            .map((json) => MealCategory.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  // 2. Get all areas (countries) that have actual meals in the free database
  Future<List<String>> getAreas() async {
    final response = await http.get(Uri.parse('$baseUrl/list.php?a=list'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        final allAreas = (data['meals'] as List)
            .map((json) => json['strArea'] as String)
            .toList();

        // Standard traditional cuisines supported in the database with actual recipes
        const verifiedAreas = {
          'American', 'British', 'Canadian', 'Chinese', 'Croatian', 'Dutch',
          'Egyptian', 'Filipino', 'French', 'Greek', 'Indian', 'Irish',
          'Italian', 'Jamaican', 'Japanese', 'Kenyan', 'Malaysian', 'Mexican',
          'Moroccan', 'Polish', 'Portuguese', 'Russian', 'Spanish', 'Thai',
          'Tunisian', 'Turkish', 'Vietnamese'
        };

        return allAreas.where((area) => verifiedAreas.contains(area)).toList();
      }
    }
    return [];
  }

  // 3. Get a random meal
  Future<Meal?> getRandomMeal() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null && (data['meals'] as List).isNotEmpty) {
        return Meal.fromJson(data['meals'][0]);
      }
    }
    return null;
  }

  // 4. Search meals by name
  Future<List<Meal>> searchMealsByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$name'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => Meal.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  // 5. Get full details of a meal by ID
  Future<Meal?> getMealDetails(String idMeal) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$idMeal'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null && (data['meals'] as List).isNotEmpty) {
        return Meal.fromJson(data['meals'][0]);
      }
    }
    return null;
  }

  // 6. Filter meals by category
  Future<List<Meal>> filterByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => Meal.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  // 7. Filter meals by area
  Future<List<Meal>> filterByArea(String area) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?a=$area'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => Meal.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  // 8. Filter meals by main ingredient
  Future<List<Meal>> filterByIngredient(String ingredient) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?i=$ingredient'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => Meal.fromJson(json))
            .toList();
      }
    }
    return [];
  }
}
