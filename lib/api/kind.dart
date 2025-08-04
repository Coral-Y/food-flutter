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

  /// 添加分类
  Future<bool> add(Kind kind) async {
    try {
      await BaseApi.request.post("/kinds", data: {
        "name": kind.name,
        "icon": kind.icon,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 编辑分类
  Future<bool> edit(Kind kind) async {
    try {
      await BaseApi.request.put(
          "/kinds/${kind.id is String ? int.parse(kind.id.toString()) : kind.id}",
          data: {
            "name": kind.name,
            "icon": kind.icon,
          });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 删除分类
  Future<bool> delete(int id) async {
    try {
      await BaseApi.request.delete("/kinds/$id");
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
