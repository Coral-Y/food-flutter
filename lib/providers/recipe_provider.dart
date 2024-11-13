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
      String res = await RecipeApi().changed(updatedRecipe);
      final index =
          _recipes.indexWhere((recipe) => recipe.id == updatedRecipe.id);
      if (index != -1) {
        _recipes[index] = updatedRecipe;
        _recipes[index].image = res;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // 获取食谱列表
  Future<void> getRecipeList(int page, int kindId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      var res = await RecipeApi().list(current: page, kindId: kindId);
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
    final index = _recipes.indexWhere((recipe) => recipe.id == recipeId);
    if (index == -1) return false;

    // 临时保存要删除的项
    final Recipe removedRecipe = _recipes[index];
    // 临时从UI列表中移除项
    _recipes.removeAt(index);
    notifyListeners();

    try {
      // 发送删除请求
      bool isDeleted = await RecipeApi().delete(recipeId);

      if (isDeleted) {
        return true;
      } else {
        // 请求失败，恢复项
        _recipes.insert(index, removedRecipe);
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Error deleting recipe: $e");
      // 捕获异常，恢复项
      _recipes.insert(index, removedRecipe);
      notifyListeners();
      return false;
    }
  }
}
