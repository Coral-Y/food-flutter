import 'package:food/api/base.dart';
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
      // var response = await BaseApi.request.get("/icons", params: {
      //   'type': type,
      // });
      var response = {
        "list": [
          {"id": 2, "cnName": "素菜", "enName": "vegetable", "type": "dish"},
          {"id": 3, "cnName": "荤菜", "enName": "meat", "type": "dish"},
          {"id": 4, "cnName": "主食", "enName": "staple-food", "type": "dish"},
          {"id": 5, "cnName": "汤羹", "enName": "soup", "type": "dish"},
          {"id": 6, "cnName": "饮品", "enName": "beverage", "type": "dish"},
          {"id": 7, "cnName": "甜品", "enName": "dessert", "type": "dish"}
        ],
        "total": 1,
        "current": 1,
        "pageSize": 10,
        "totalPage": 1
      };
      return Pager<FoodIcon>.fromJson(
          response, (json) => FoodIcon.fromJson(json as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }
}
