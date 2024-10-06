import 'package:food/api/base.dart';
import 'package:food/model/exception.dart';
import 'package:food/model/common.dart';
import 'package:food/model/icon.dart';

class IconApi extends BaseApi {
  //图标列表
  Future<Pager<FoodIcon>> list(String type) async {
    try {
      var response = await request.get("/icons", params: {
        'type': type,
      });
      print(response);
      response = Pager<FoodIcon>.fromJson(
          response, (json) => FoodIcon.fromJson(json as Map<String, dynamic>));
      return response;
    } catch (e) {
      if (e is ApiException) {
        print("错误码 ： ${e.code}, 错误 ：  ${e.message}");
      } else {
        print("其他错误: $e");
      }
    }
    return Pager<FoodIcon>(
      current: 0,
      pageSize: 0,
      total: 0,
      totalPage: 0,
      list: [],
    );
  }
}
