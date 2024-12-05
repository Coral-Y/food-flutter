import 'package:food/api/base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  AuthApi._();
  static final AuthApi _instance = AuthApi._();
  factory AuthApi() => _instance;

  // 获取验证码
  Future<bool> getCode(String phone) async {
    try {
      await BaseApi.request.get("/auth", params: {"phone": phone});
      return true;
    } catch (e) {
      print("Error getting code: $e");
      return false;
    }
  }

  // 注册
  Future<void> register(String phone, String code) async {
    try {
      await BaseApi.request
          .post("/auth/register", data: {"phone": phone, "code": code});
    } catch (e) {}
  }

  // 登录
  Future<bool> signIn(String phone, String password) async {
    try {
      print('登录');
      var response = await BaseApi.request.post("/auth/signIn", data: {
        "phone": phone,
        "password": password,
      });
      if (response == null) {
        print('登录响应为空');
        return false;
      }
      // 保存 token
      try {
        await saveToken(response.toString());
        // 设置请求头
        BaseApi.request.setHeaders({'Authorization': 'Bearer $response'});
        return true;
      } catch (e) {
        print('保存 token 失败: $e');
        return false;
      }
    } catch (e) {
      print("Error signing in: $e");
      return false;
    }
  }

  // 保存 token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // 获取 token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 检查是否已登录
  Future<bool> checkLogin() async {
    String? token = await getToken();
    if (token != null && token.isNotEmpty) {
      // 设置请求头
      BaseApi.request.setHeaders({'Authorization': 'Bearer $token'});
      return true;
    }
    return false;
  }

  // 退出登录
  Future<bool> logout() async {
    try {
      await BaseApi.request.get("/accounts/signout");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      return true;
    } catch (e) {
      return false;
    }
  }
}
