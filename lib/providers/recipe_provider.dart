import 'package:flutter/material.dart';
import 'package:food/model/recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  void setRecipes(List<Recipe> recipes) {
    _recipes = recipes;
    notifyListeners();
  }

  void updateRecipe(Recipe updatedRecipe) {
    final index =
        _recipes.indexWhere((recipe) => recipe.id == updatedRecipe.id);
    if (index != -1) {
      _recipes[index] = updatedRecipe;
      notifyListeners();
    }
  }

  // 可以添加其他管理食谱的方法
}
