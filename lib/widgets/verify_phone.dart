import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/api/auth.dart';

class VerifyPhone extends StatefulWidget {
  final void Function(String, String) submit;
  const VerifyPhone({required this.submit, super.key});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool agreed = false;
  bool canGetCode = true; // 是否可以获取验证码
  int _countdown = 60; // 倒计时秒数
  Timer? _timer; // 倒计时计时器
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _phoneController.text = '';
    _codeController.text = '';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              label: Text('手机号'),
              border: OutlineInputBorder(),
              counterText: "", // 隐藏字符计数器
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
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
                  type: 'secondary',
                  onPressed: canGetCode ? sendCode : () => {},
                  text: canGetCode ? '获取验证码' : '${_countdown}s后重试',
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 40),
          child: SizedBox(
            width: double.infinity,
            child: CButton(
                onPressed: () {
                  widget.submit(_phoneController.text, _codeController.text);
                },
                text: '注册'),
          ),
        ),
      ],
    );
  }
}
