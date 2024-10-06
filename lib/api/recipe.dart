import 'package:food/api/base.dart';
import 'package:food/model/exception.dart';

class RecipeApi extends BaseApi {
  //食谱列表
  Future list(
      {int? current, int? pageSize, int? kindId, String? keyword}) async {
    try {
      var response = await request.get("/recipes", params: {
        'accountId': 1,
        'current': current ?? 1,
        'pageSize': pageSize ?? 10,
      });
      print(response);
      return response;
    } catch (e) {
      if (e is ApiException) {
        print("错误码 ： ${e.code}, 错误 ：  ${e.message}");
      } else {
        print("其他错误: $e");
      }
    }
  }
}
