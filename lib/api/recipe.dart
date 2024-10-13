import 'package:flutter/material.dart';
import 'package:food/api/base.dart';
import 'package:food/model/exception.dart';
import 'package:food/model/common.dart';
import 'package:food/model/recipe.dart';

class RecipeApi {
  RecipeApi._();

  static final RecipeApi _instance = RecipeApi._(); // 静态实例

  factory RecipeApi() {
    return _instance;
  }

  var rlist = {
    "list": [
      {
        "id": 2,
        "accountId": 1,
        "kindId": 3,
        "name": "小龙虾",
        "image": "assets/images/salad.png",
        "ingredients": [],
        "seasonings": [],
        "instructions": []
      }
    ],
    "total": 1,
    "current": 1,
    "pageSize": 10,
    "totalPage": 1
  };
  var rDetail = {
    "id": 2,
    "accountId": 1,
    "kind": {
      'id': 1,
      "name": '荤菜',
      "icon": "meat",
    },
    "name": "小龙虾",
    "image": "assets/images/salad.png",
    "ingredients": ['小龙虾', '洋葱', '姜'],
    "seasonings": [],
    "instructions": ['把鱿鱼表面清洗干净', '热油，放入蒜片和姜片', '热油', ' 搅拌均匀']
  };

  //食谱列表
  Future<Pager<Recipe>> list(
      {int? current, int? pageSize, int? kindId, String? keyword}) async {
    try {
      // var response = await BaseApi.request.get("/recipes", params: {
      //   'accountId': 1,
      //   'current': current ?? 1,
      //   'pageSize': pageSize ?? 10,
      // });
      var response = rlist;
      return Pager<Recipe>.fromJson(
          response, (json) => Recipe.fromJson(json as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }

  //获取食谱详情
  Future<Recipe> detail(int id) async {
    try {
      // var response = await BaseApi.request.get("/recipes/$id");
      var response = rDetail;
      return Recipe.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  //创建食谱
  Future<bool> created(Recipe recipe) async {
    try {
      var data = {
        "name": recipe.name,
        "image": recipe.image,
        "ingredients": recipe.ingredients,
        "kindId": recipe.kind!.id,
        "seasonings": recipe.seasonings,
        "instructions": recipe.instructions,
      };
      await BaseApi.request.post("/recipes", data: data);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  //修改食谱
  Future<bool> changed(Recipe recipe) async {
    try {
      var data = {
        "name": recipe.name,
        "image": recipe.image,
        "ingredients": recipe.ingredients,
        "kindId": recipe.kind!.id,
        "seasonings": recipe.seasonings,
        "instructions": recipe.instructions,
      };
      await BaseApi.request.put("/recipes/${recipe.id}", data: data);
      return true;
    } catch (e) {
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
