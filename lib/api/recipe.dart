import 'package:food/api/base.dart';
import 'package:food/model/common.dart';
import 'package:food/model/recipe.dart';
import 'package:dio/dio.dart';
import 'package:food/utils/common.dart';

class RecipeApi {
  RecipeApi._();

  static final RecipeApi _instance = RecipeApi._(); // 静态实例

  factory RecipeApi() {
    return _instance;
  }

  //食谱列表
  Future<Pager<Recipe>> list(
      {int? current, int? pageSize, int? kindId, String? keyword}) async {
    try {
      Map<String, dynamic> params = {
        'current': current ?? 1,
        'pageSize': pageSize ?? 10,
      };

      if (kindId != null && kindId != 0) {
        params['kindId'] = kindId;
      }

      if (keyword != null && keyword != '') {
        params['keyword'] = keyword;
      }

      var response = await BaseApi.request.get("/recipes", params: params);
      print('Detail response: $response');
      return Pager<Recipe>.fromJson(
          response, (json) => Recipe.fromJson(json as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }

  //获取食谱详情
  Future<Recipe> detail(int id) async {
    try {
      var response = await BaseApi.request.get("/recipes/$id");
      return Recipe.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  //创建食谱
  Future<void> created(Recipe recipe) async {
    await BaseApi.request.post("/recipes", data: {
      'name': recipe.name,
      'kindId': recipe.kind!.id,
      'image': recipe.image,
      'ingredients': arrayToString(recipe.ingredients),
      'seasonings': arrayToString(recipe.seasonings),
      'instructions': arrayToString(recipe.instructions),
    });
  }

  //修改食谱
  Future<String> changed(Recipe recipe) async {
    var res = await BaseApi.request.put(
        "/recipes/${recipe.id is String ? int.parse(recipe.id.toString()) : recipe.id}",
        data: {
          'name': recipe.name,
          'kindId': recipe.kind!.id,
          'image': recipe.image,
          'ingredients': arrayToString(recipe.ingredients),
          'seasonings': arrayToString(recipe.seasonings),
          'instructions': arrayToString(recipe.instructions),
        });
    return res['image'];
  }

  //删除食谱
  Future<bool> delete(int id) async {
    try {
      await BaseApi.request.delete("/recipes/$id");
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
