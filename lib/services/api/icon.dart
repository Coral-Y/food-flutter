import 'package:food/services/api/base.dart';
import 'package:food/model/common.dart';
import 'package:food/model/icon.dart';

class IconApi {
  IconApi._();

  static final IconApi _instance = IconApi._(); // 静态实例

  factory IconApi() {
    return _instance;
  }

  //图标列表
  Future<Pager<FoodIcon>> list(String type) async {
    try {
      var response = await BaseApi.request.get("/icons", params: {
        'type': type,
      });

      return Pager<FoodIcon>.fromJson(
          response, (json) => FoodIcon.fromJson(json as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }
}
