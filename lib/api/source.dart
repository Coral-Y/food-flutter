import 'package:dio/dio.dart';
import 'package:food/api/base.dart';

class SourceApi {
  SourceApi._();

  static final SourceApi _instance = SourceApi._(); // 静态实例

  factory SourceApi() {
    return _instance;
  }

  //  新增资源
  Future<String> add(String source, String kind) async {
    var formData = FormData.fromMap({"type": "image", "kind": kind});
    formData.files.add(MapEntry(
      "source",
      await MultipartFile.fromFile(source, filename: "image.jpg"),
    ));
    // 发送请求
    var res = await BaseApi.request.post("/sources", data: formData);

    return res['source'];
  }
}
