import 'package:flutter/material.dart';
import 'package:food/api/auth.dart';
import 'package:food/api/accounts.dart';
import 'package:food/widgets/header.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 头部标题和返回按钮
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Header(title: '设置'),
            ),

            // 修改基础信息
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/editInfo');
              },
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: const Text(
                  '修改基础信息',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Container(
              height: 1,
              color: const Color(0xfff5f5f5),
            ),

            // 修改密码
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/editPassword');
              },
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: const Text(
                  '修改密码',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            // 中间可以添加其他设置项

            // 底部退出按钮
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CButton(
                onPressed: () async {
                  try {
                    // 清除 token
                    await AuthApi().logout();
                    // 清除用户信息缓存
                    await AccountsApi().clearUserInfo();

                    if (!context.mounted) return;
                    // 显示提示
                    CSnackBar(message: '退出成功').show(context);
                    // 返回登录页，并清除所有路由
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (route) => false,
                    );
                  } catch (e) {
                    print('退出登录失败: $e');
                    if (!context.mounted) return;
                    CSnackBar(message: '退出失败，请稍后再试').show(context);
                  }
                },
                text: '退出登录',
                type: 'danger',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
