import 'package:flutter/material.dart';
import 'package:food/api/accounts.dart';
import 'package:food/api/auth.dart';
import 'package:food/model/exception.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/widgets/header.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // 提交设置
  void submit() async {
    if (_oldPasswordController.text.isEmpty) {
      CSnackBar(message: '请输入旧密码').show(context);
      return;
    }
    if (_passwordController.text.isEmpty) {
      CSnackBar(message: '请输入新密码').show(context);
      return;
    }
    if (_confirmController.text.isEmpty) {
      CSnackBar(message: '请输入确认密码').show(context);
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      CSnackBar(message: '确认密码与新密码不一致，请重新输入').show(context);
      return;
    }
    try {
      await AccountsApi().editPassword(_oldPasswordController.text,
          _passwordController.text, _confirmController.text);
      // 清除 token
      await AuthApi().logout();
      // 清除用户信息缓存
      await AccountsApi().clearUserInfo();
      CSnackBar(message: '修改成功，请重新登陆').show(context);
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } on ApiException catch (e) {
      CSnackBar(message: e.message).show(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: '设置密码'),
            TextField(
              obscureText: true,
              controller: _oldPasswordController,
              decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  label: Text('旧密码'),
                  border: OutlineInputBorder(),
                  counterText: ""),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  label: Text('新密码'),
                  border: OutlineInputBorder(),
                  counterText: ""),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              controller: _confirmController,
              decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  label: Text('确认密码'),
                  border: OutlineInputBorder(),
                  counterText: ""),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: CButton(onPressed: submit, text: '确认'),
            )
          ],
        ),
      )),
    );
  }
}
