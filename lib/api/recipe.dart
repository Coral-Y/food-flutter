import 'package:food/utils/request.dart';
import 'package:food/model/exception.dart';

class RecipeApi {
  Request request = Request("http://url");

  Future list(
      {int? current, int? pageSize, int? kindId, String? keyword}) async {
    request.setHeaders({
      'Authorization': 'token',
    });
    try {
      var response = await request.get("/recipes", params: {
        'current': current ?? 1,
        'pageSize': pageSize ?? 10,
        'kindId': kindId,
        'keyword': keyword
      });
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
