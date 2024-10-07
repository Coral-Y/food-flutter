import 'package:food/api/base.dart';
import 'package:food/model/common.dart';
import 'package:food/model/kind.dart';

class KindApi {
  KindApi._();

  static final KindApi _instance = KindApi._(); // 静态实例

  factory KindApi() {
    return _instance;
  }

  //分类列表
  Future<Pager<Kind>> list({
    int? current,
    int? pageSize,
  }) async {
    try {
      // var response = await BaseApi.request.get("/kinds", params: {
      //   'current': current ?? 1,
      //   'pageSize': pageSize ?? 10,
      // });
      var response = {
        "list": [
          {"id": 1, "accountId": 3, "name": "素菜", "icon": "vegetable"},
          {"id": 2, "accountId": 3, "name": "荤菜", "icon": "meat"},
          {"id": 3, "accountId": 3, "name": "主食", "icon": "staple-food"},
          {"id": 4, "accountId": 3, "name": "汤羹", "icon": "soup"},
          {"id": 5, "accountId": 3, "name": "饮品", "icon": "beverage"}
        ],
        "total": 6,
        "current": 1,
        "pageSize": 5,
        "totalPage": 2
      };
      return Pager<Kind>.fromJson(
          response, (json) => Kind.fromJson(json as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }
}
