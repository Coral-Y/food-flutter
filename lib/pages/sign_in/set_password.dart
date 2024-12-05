import 'package:flutter/material.dart';
import 'package:food/api/auth.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/widgets/header.dart';

class SetPasswordord extends StatefulWidget {
  const SetPasswordord({super.key});

  @override
  State<SetPasswordord> createState() => _SetPasswordordState();
}

class _SetPasswordordState extends State<SetPasswordord> {
  String phone = '';
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
    if (_passwordController.text.isEmpty) {
      CSnackBar(message: '请输入密码').show(context);
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
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  label: Text('密码'),
                  border: OutlineInputBorder(),
                  counterText: ""),
            ),
            const SizedBox(
              height: 15,
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
