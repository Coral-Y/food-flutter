import 'package:flutter/material.dart';
import 'package:food/api/accounts.dart';
import 'package:food/api/auth.dart';
import 'package:food/model/exception.dart';
import 'package:food/utils/validate.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/widgets/header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  bool _obscuredOld = true;
  bool _obscuredNew = true;
  bool _obscuredConfirm = true;
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
      CSnackBar(message: '请输入正确的旧密码').show(context);
      return;
    }
    if (_passwordController.text.isEmpty ||
        !isPassword(_passwordController.text)) {
      CSnackBar(message: '请输入正确的新密码').show(context);
      return;
    }
    if (_confirmController.text.isEmpty ||
        _passwordController.text != _confirmController.text) {
      CSnackBar(message: '请输入正确的确认密码').show(context);
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: '修改密码'),
            const SizedBox(
              height: 5,
            ),
            const Text(
              '密码格式：大小写字母与数字的组合',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              obscureText: _obscuredOld,
              controller: _oldPasswordController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  label: const Text('旧密码'),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscuredOld = !_obscuredOld;
                      });
                    },
                    icon: _obscuredOld
                        ? const Iconify(
                            Ic.outline_visibility_off,
                            size: 18,
                          )
                        : const Iconify(
                            Ic.outline_visibility,
                            size: 18,
                          ),
                  ),
                  counterText: ""),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: _obscuredNew,
              controller: _passwordController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  label: const Text('新密码'),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscuredNew = !_obscuredNew;
                      });
                    },
                    icon: _obscuredNew
                        ? const Iconify(
                            Ic.outline_visibility_off,
                            size: 18,
                          )
                        : const Iconify(
                            Ic.outline_visibility,
                            size: 18,
                          ),
                  ),
                  counterText: ""),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: _obscuredConfirm,
              controller: _confirmController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  label: const Text('确认密码'),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscuredConfirm = !_obscuredConfirm;
                      });
                    },
                    icon: _obscuredConfirm
                        ? const Iconify(
                            Ic.outline_visibility_off,
                            size: 18,
                          )
                        : const Iconify(
                            Ic.outline_visibility,
                            size: 18,
                          ),
                  ),
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
