class Meal {
  final String idMeal;
  final String strMeal;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strMealThumb;
  final String? strTags;
  final String? strYoutube;
  final List<IngredientMeasure> ingredients;

  Meal({
    required this.idMeal,
    required this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<IngredientMeasure> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredientsList.add(IngredientMeasure(
          ingredient: ingredient.toString().trim(),
          measure: (measure != null && measure.toString().trim().isNotEmpty)
              ? measure.toString().trim()
              : '',
        ));
      }
    }

    return Meal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strTags: json['strTags'],
      strYoutube: json['strYoutube'],
      ingredients: ingredientsList,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
    };
    for (int i = 0; i < ingredients.length; i++) {
      json['strIngredient${i + 1}'] = ingredients[i].ingredient;
      json['strMeasure${i + 1}'] = ingredients[i].measure;
    }
    return json;
  }
}

class IngredientMeasure {
  final String ingredient;
  final String measure;

  IngredientMeasure({
    required this.ingredient,
    required this.measure,
  });

  Map<String, dynamic> toJson() {
    return {
      'ingredient': ingredient,
      'measure': measure,
    };
  }

  factory IngredientMeasure.fromJson(Map<String, dynamic> json) {
    return IngredientMeasure(
      ingredient: json['ingredient'] ?? '',
      measure: json['measure'] ?? '',
    );
  }
}

class MealCategory {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  MealCategory({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      idCategory: json['idCategory'] ?? '',
      strCategory: json['strCategory'] ?? '',
      strCategoryThumb: json['strCategoryThumb'] ?? '',
      strCategoryDescription: json['strCategoryDescription'] ?? '',
    );
  }
}
