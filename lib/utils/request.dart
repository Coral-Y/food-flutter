import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food/api/accounts.dart';
import 'package:food/main.dart';
import 'package:food/model/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request {
  static late Dio dio;

  Request(String baseUrl) {
    dio = _createDio(baseUrl);
  }

  // 创建Dio实例
  Dio _createDio(String baseUrl) {
    Dio instance = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    instance.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) async {
        // 捕获 401 错误
        if (error.response?.statusCode == 401) {
          // 清除token
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          // 清除用户信息缓存
          await AccountsApi().clearUserInfo();
          // 跳转到登录页面
          final context = navigatorKey.currentContext;
          if (context != null) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          }
        }
        return handler.next(error); // 继续抛出错误
      },
    ));
    return instance;
  }

  // 更新请求头
  void setHeaders(Map<String, dynamic> headers) {
    dio.options.headers.addAll(headers);
  }

  // 发送请求
  Future<T> request<T>(
    String path, {
    String method = 'get',
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, dynamic>? headers,
    Options? options,
  }) async {
    try {
      Response response = await dio.request(path,
          data: data,
          queryParameters: params,
          options: Options(
            method: method,
            headers: headers,
          ));
      if (response.data is Map) {
        var dataMap = response.data as Map<String, dynamic>;
        if (dataMap.containsKey('data')) {
          return dataMap['data'];
        }
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

  Future<T> get<T>(String path,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) {
    return request(path, method: 'GET', params: params);
  }

  Future<T> post<T>(String path,
      {dynamic data, Map<String, dynamic>? headers, Options? options}) {
    return request(path,
        method: 'POST', data: data, headers: headers, options: options);
  }

  Future<T> put<T>(String path,
      {dynamic data, Map<String, dynamic>? headers, Options? options}) {
    return request(path,
        method: 'PUT', data: data, headers: headers, options: options);
  }

  Future<T> delete<T>(String path,
      {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    return request(path, method: 'DELETE', data: data);
  }

  Future<T> patch<T>(String path,
      {dynamic data, Map<String, dynamic>? headers, Options? options}) {
    return request(path,
        method: 'PATCH', data: data, headers: headers, options: options);
  }
}
