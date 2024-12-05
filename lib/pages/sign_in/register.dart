import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food/model/exception.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/header.dart';
import 'package:flutter/services.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/api/auth.dart';
import 'package:food/widgets/verify_phone.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool agreed = false;
  bool canGetCode = true; // 是否可以获取验证码
  int _countdown = 60; // 倒计时秒数
  Timer? _timer; // 倒计时计时器

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _phoneController.text = '13049363874';
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

  // 注册
  void register() async {
    if (_phoneController.text.length != 11) {
      CSnackBar(message: '请输入正确的手机号').show(context);
      return;
    }
    if (_codeController.text.length != 6) {
      CSnackBar(message: '请输入6位验证码').show(context);
      return;
    }

    try {
      await AuthApi().register(
        _phoneController.text,
        _codeController.text,
      );
      Navigator.of(context).pushReplacementNamed('/setPassword',
          arguments: {"phone": _phoneController.text});
    } on ApiException catch (e) {
      CSnackBar(message: e.message).show(context);
    } catch (e) {
      print("Error loading user info: $e");
      CSnackBar(message: '注册失败').show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: VerifyPhone(
                submit: register,
              ))),
    );
  }
}
