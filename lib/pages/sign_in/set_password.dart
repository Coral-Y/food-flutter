import 'package:flutter/material.dart';
import 'package:food/api/auth.dart';
import 'package:food/utils/validate.dart';
import 'package:food/widgets/c_button.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/widgets/header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class SetPasswordord extends StatefulWidget {
  const SetPasswordord({super.key});

  @override
  State<SetPasswordord> createState() => _SetPasswordordState();
}

class _SetPasswordordState extends State<SetPasswordord> {
  String phone = '';
  bool _obscuredPassword = true;
  bool _obscuredConfirm = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 在 initState 中获取参数
    Future.microtask(() {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        phone = args['phone'];
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // 提交设置
  void submit() async {
    if (_passwordController.text.isEmpty ||
        !isPassword(_passwordController.text)) {
      CSnackBar(message: '请输入正确的密码').show(context);
      return;
    }
    if (_confirmController.text.isEmpty ||
        _passwordController.text != _confirmController.text) {
      CSnackBar(message: '请输入正确的确认密码').show(context);
      return;
    }
    try {
      await AuthApi().setPassword(
          phone, _passwordController.text, _confirmController.text);
      CSnackBar(message: '设置成功').show(context);
      Navigator.of(context).pushReplacementNamed('/login');
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
            const Header(
              title: '设置密码',
              showIcon: false,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text('注册成功啦！'),
            const Text('您的初始密码是：Aa123456，可通过以下步骤重新设置密码'),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: _obscuredPassword,
              controller: _passwordController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  label: const Text('密码'),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscuredPassword = !_obscuredPassword;
                      });
                    },
                    icon: _obscuredPassword
                        ? const Iconify(
                            Ic.outline_visibility_off,
                            size: 18,
                          )
                        : const Iconify(
                            Ic.outline_visibility,
                            size: 18,
                          ),
                  ),
                  border: const OutlineInputBorder(),
                  counterText: ""),
            ),
            const SizedBox(
              height: 15,
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
            Row(
              children: [
                Expanded(
                  child: CButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      type: 'secondary',
                      text: '直接登录'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: CButton(onPressed: submit, text: '确认')),
              ],
            )
          ],
        ),
      )),
    );
  }
}
