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
      print(id);
      var response = await BaseApi.request.get("/recipes/$id");
      print(Recipe.fromJson(response));
      return Recipe.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  //创建食谱
  Future<void> created(Recipe recipe) async {
    var formData = FormData.fromMap({
      "name": recipe.name,
      "kindId": recipe.kind!.id,
      "ingredients": arrayToString(recipe.ingredients),
      "seasonings": arrayToString(recipe.seasonings),
      "instructions": arrayToString(recipe.instructions),
    });
    formData.files.add(MapEntry(
      "image",
      await MultipartFile.fromFile(recipe.image, filename: "image.jpg"),
    ));

    // 发送请求
    await BaseApi.request.post("/recipes", data: formData);
  }

  //修改食谱
  Future<String> changed(Recipe recipe) async {
    try {
      print(recipe.image);
      var formData = FormData.fromMap({
        'id': recipe.id,
        "name": recipe.name,
        "ingredients": arrayToString(recipe.ingredients),
        "seasonings": arrayToString(recipe.seasonings),
        "instructions": arrayToString(recipe.instructions),
        "kindId": recipe.kind!.id,
      });
      // 处理图片
      // 修改图片处理逻辑
      if (recipe.image.isNotEmpty) {
        if (recipe.image.startsWith('http://') ||
            recipe.image.startsWith('https://')) {
          print('使用现有网络图片'); // 添加日志
        } else {
          print('添加新的本地图片'); // 添加日志
          formData.files.add(MapEntry(
            "image",
            await MultipartFile.fromFile(recipe.image, filename: "image.jpg"),
          ));
        }
      }
      var res = await BaseApi.request.put(
          "/recipes/${recipe.id is String ? int.parse(recipe.id.toString()) : recipe.id}",
          data: formData);

      return res['image'];
    } catch (e) {
      print(e);
      rethrow;
    }
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
