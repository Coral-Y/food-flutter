import 'package:dio/dio.dart';

class Request {
  static late Dio dio;

  Request(String baseUrl) {
    dio = _createDio(baseUrl);
  }

  // 创建Dio实例
  Dio _createDio(String baseUrl) {
    Dio instance = Dio(BaseOptions(
        baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10)));

    return instance;
  }

  // 发送请求
  static Future<T> request<T>(String path, {String method = 'get'}) async {
    try {
      Response response = await dio.request(path);
      if (response.data is Map) {
        return response.data;
      }
      return Future.value();
    } on DioException catch (e) {
      // 处理DioException异常
      return Future.error(e);
    } catch (e) {
      // 处理其他异常
      return Future.error(e);
    }
  }
}
