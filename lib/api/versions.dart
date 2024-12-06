import 'package:food/api/base.dart';
import 'package:food/model/version.dart';

class VersionApi {
  VersionApi._();

  static final VersionApi _instance = VersionApi._(); // 静态实例

  factory VersionApi() {
    return _instance;
  }

  // 最新版本信息
  Future<Version> last() async {
    try {
      var response = await BaseApi.request.get("/versions/last");
      return Version.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
