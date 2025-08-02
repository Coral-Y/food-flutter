import 'package:food/api/base.dart';
import 'package:food/model/common.dart';
import 'package:food/model/module.dart';

class ModulesApi {
  ModulesApi._();

  static final ModulesApi _instance = ModulesApi._(); // 静态实例

  factory ModulesApi() {
    return _instance;
  }

  //模块列表
  Future<Pager<Module>> list({
    int? current,
    int? pageSize,
  }) async {
    try {
      var response = await BaseApi.request.get("/modules", params: {
        'current': current ?? 1,
        'pageSize': pageSize ?? 10,
      });
      return Pager<Module>.fromJson(
          response, (json) => Module.fromJson(json as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }
}
