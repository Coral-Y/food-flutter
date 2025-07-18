import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:food/api/base.dart';
import 'package:food/model/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountsApi {
  AccountsApi._();
  static final AccountsApi _instance = AccountsApi._();
  factory AccountsApi() => _instance;

  static const String _userInfoKey = 'user_info';

  // 获取用户信息
  Future<UserInfo> getUserInfo() async {
    // 从缓存获取
    UserInfo? cachedInfo = await _getCachedUserInfo();
    if (cachedInfo != null) {
      return cachedInfo;
    }
    var response = await BaseApi.request.get("/accounts/me");
    var userInfo = UserInfo.fromJson(response);

    // 缓存用户信息
    await _cacheUserInfo(userInfo);
    return userInfo;
  }

  // 从缓存中获取用户信息
  Future<UserInfo?> _getCachedUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInfoStr = prefs.getString(_userInfoKey);
      if (userInfoStr != null) {
        Map<String, dynamic> userInfoMap = json.decode(userInfoStr);
        return UserInfo.fromJson(userInfoMap);
      }
      return null;
    } catch (e) {
      print("获取用户信息出错: $e");
      return null;
    }
  }

  // 缓存用户信息
  Future<void> _cacheUserInfo(UserInfo userInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String userInfoStr = json.encode(userInfo.toJson());
      await prefs.setString(_userInfoKey, userInfoStr);
    } catch (e) {
      print("缓存用户信息出错: $e");
    }
  }

  // 清除缓存的用户信息
  Future<void> clearUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userInfoKey);
    } catch (e) {
      print("清除缓存的用户信息出错: $e");
    }
  }

  // 修改用户信息
  Future<bool> updateUserInfo({
    required String name,
    String? avatarPath,
  }) async {
    try {
      var formData = FormData.fromMap({
        "name": name,
      });
      if (avatarPath != null && avatarPath.isNotEmpty) {
        if (avatarPath.startsWith('http://') ||
            avatarPath.startsWith('https://')) {
          print('使用现有网络图片');
        } else {
          formData.files.add(
            MapEntry(
              "avatar",
              await MultipartFile.fromFile(avatarPath, filename: "avatar.png"),
            ),
          );
        }
      }
      await BaseApi.request.put("/accounts/me", data: formData);
      await clearUserInfo();
      return true;
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }

  // 修改密码
  Future<void> editPassword(
      String oldPassword, String password, String confirm) async {
    await BaseApi.request.put("/accounts/password", data: {
      "oldPassword": oldPassword,
      "password": password,
      "confirm": confirm
    });
  }
}
