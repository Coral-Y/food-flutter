import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food/widgets/c_button.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cib.dart';
import 'package:flutter/services.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/api/auth.dart';
import 'package:food/api/accounts.dart';
import 'package:food/model/user_info.dart';
import 'package:food/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool agreed = false;
  bool canGetCode = true; // 是否可以获取验证码
  int _countdown = 60; // 倒计时秒数
  Timer? _timer; // 倒计时计时器

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _phoneController.text = '15900158829';
    _codeController.text = '000000';
    agreed = true;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // 开始验证码倒计时
  void startCountdown() {
    setState(() {
      canGetCode = false;
      _countdown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          canGetCode = true;
          timer.cancel();
        }
      });
    });
  }

  // 发送验证码
  void sendCode() async {
    if (!canGetCode) return;
    // 验证手机号格式
    String phone = _phoneController.text;
    if (phone.length != 11) {
      CSnackBar(message: '请输入正确的手机号').show(context);
      return;
    }
    bool isSuccess = await AuthApi().getCode(phone);
    if (isSuccess) {
      startCountdown(); // 倒计时
      CSnackBar(message: '验证码已发送').show(context);
    } else {
      CSnackBar(message: '验证码发送失败').show(context);
    }
  }

  // 登录
  void signIn() async {
    if (!agreed) {
      CSnackBar(message: '请先同意用户协议和隐私协议').show(context);
      return;
    }
    if (_phoneController.text.length != 11) {
      CSnackBar(message: '请输入正确的手机号').show(context);
      return;
    }
    if (_codeController.text.length != 6) {
      CSnackBar(message: '请输入6位验证码').show(context);
      return;
    }

    bool isLogin = await AuthApi().signIn(
      _phoneController.text,
      _codeController.text,
    );
    if (isLogin) {
      try {
        UserInfo userInfo = await AccountsApi().getUserInfo();
        if (!mounted) return;
        context.read<UserProvider>().setUserInfo(userInfo);
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print("Error loading user info: $e");
        CSnackBar(message: '获取用户信息失败').show(context);
      }
    } else {
      CSnackBar(message: '登录失败').show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/cook.png',
            width: double.infinity,
            height: 320,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                label: Text('手机号'),
                border: OutlineInputBorder(),
                counterText: "", // 隐藏字符计数器
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                      label: Text('验证码'),
                      border: OutlineInputBorder(),
                      counterText: "", // 隐藏字符计数器
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 120,
                  child: CButton(
                    onPressed: canGetCode ? sendCode : () => {},
                    text: canGetCode ? '获取验证码' : '${_countdown}s后重试',
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                  value: agreed,
                  onChanged: (bool? value) {
                    setState(() {
                      agreed = value!;
                    });
                  }),
              const Text('已阅读并同意'),
              GestureDetector(
                child: const Text(
                  '《用户协议》',
                  style: TextStyle(
                      color: Color(0xffd4939d),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xffd4939d)),
                ),
              ),
              const Text('和'),
              GestureDetector(
                child: const Text(
                  '《隐私协议》',
                  style: TextStyle(
                      color: Color(0xffd4939d),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xffd4939d)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 40),
            child: SizedBox(
              width: double.infinity,
              child: CButton(onPressed: signIn, text: '登录'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 45),
            child: Row(
              children: [
                Expanded(
                    child: Divider(
                  color: Color(0xff333333),
                )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text('其他方式登录'),
                ),
                Expanded(
                    child: Divider(
                  color: Color(0xff333333),
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      shape: BoxShape.circle,
                    ),
                    child: const Iconify(
                      Cib.qq,
                      color: Colors.blue,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      shape: BoxShape.circle,
                    ),
                    child: const Iconify(
                      Cib.wechat,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
