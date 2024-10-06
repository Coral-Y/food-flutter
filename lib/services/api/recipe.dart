import 'package:food/services/api/base.dart';
import 'package:food/model/exception.dart';
import 'package:food/model/common.dart';
import 'package:food/model/recipe.dart';

class RecipeApi {
  //食谱列表
  Future list(
      {int? current, int? pageSize, int? kindId, String? keyword}) async {
    try {
      var response = await BaseApi.request.get("/recipes", params: {
        'accountId': 1,
        'current': current ?? 1,
        'pageSize': pageSize ?? 10,
      });
      return Pager<Recipe>.fromJson(
          response, (json) => Recipe.fromJson(json as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }
}
