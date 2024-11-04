import 'package:flutter/material.dart';
import 'package:food/model/recipe.dart';
import 'package:food/api/recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false; // 用于指示数据加载状态
  String? _error; // 用于保存可能的错误信息
  int _current = 1; // 当前页码
  int _totalPage = 1; // 总页数

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get current => _current;
  int get totalPage => _totalPage;

  // 设置食谱列表
  void setRecipes(List<Recipe> recipes) {
    _recipes = recipes;
    notifyListeners();
  }

  // 更新食谱
  Future<void> updateRecipe(Recipe updatedRecipe) async {
    try {
      await RecipeApi().changed(updatedRecipe);
      final index =
          _recipes.indexWhere((recipe) => recipe.id == updatedRecipe.id);
      if (index != -1) {
        _recipes[index] = updatedRecipe;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // 获取食谱列表
  Future<void> getRecipeList(int page, int kindId) async {
    _isLoading = true; // 加载中
    _error = null;
    notifyListeners();

    try {
      var res =
          await RecipeApi().list(current: page, kindId: kindId); // 调用API获取数据

      _current = res.current;
      _totalPage = res.totalPage;

      if (page == 1) {
        _recipes = res.list;
      } else {
        _recipes.addAll(res.list);
      }
    } catch (e) {
      _error = e.toString();
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 获取下一页数据
  Future<void> getNextPage(int kindId) async {
    if (_isLoading || _current >= _totalPage) return;
    await getRecipeList(_current + 1, kindId);
  }

  // 删除食谱
  Future<bool> deleteRecipe(int recipeId) async {
    try {
      bool isDeleted = await RecipeApi().delete(recipeId);
      if (isDeleted) {
        _recipes.removeWhere((recipe) => recipe.id == recipeId);
        notifyListeners();
      }
      return isDeleted;
    } catch (e) {
      print("Error deleting recipe: $e");
      return false;
    }
  }
}
