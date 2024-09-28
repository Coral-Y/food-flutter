import 'package:dio/dio.dart';
import 'package:food/model/exception.dart';

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
  Future<T> request<T>(String path, {String method = 'get'}) async {
    try {
      Response response =
          await dio.request(path, options: Options(method: method));
      if (response.data is Map) {
        return response.data;
      }
      return Future.value();
    } on DioException catch (e) {
      final response = e.response;
      final type = e.type;
      if (type == DioExceptionType.badResponse) {
        // 服务器返回错误
        String message = response?.data?['message'];
        int code = response?.statusCode ?? response?.data?['code'];
        return Future.error(ApiException(code, message));
      } else {
        // dio其他异常，网络问题，连接超时等
        return Future.error(e);
      }
    } catch (e) {
      // 处理其他异常
      return Future.error(e);
    }
  }
}
