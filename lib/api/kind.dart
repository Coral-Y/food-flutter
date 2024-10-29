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
      var response = await BaseApi.request.get("/kinds", params: {
        'current': current ?? 1,
        'pageSize': pageSize ?? 10,
      });
      return Pager<Kind>.fromJson(
          response, (json) => Kind.fromJson(json as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }
}
