import 'package:flutter/material.dart';
import 'package:food/model/exception.dart';
import 'package:food/utils/validate.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/api/auth.dart';
import 'package:food/widgets/header.dart';
import 'package:food/widgets/verify_phone.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // 注册
  void register(String phone, String code) async {

    if (phone.length != 11 || !isPhone(phone)) {
      CSnackBar(message: '请输入正确的手机号').show(context);
      return;
    }
    if (code.length != 6) {
      CSnackBar(message: '请输入正确的验证码').show(context);
      return;
    }

    try {
      await AuthApi().register(
        phone,
        code,
      );
      Navigator.of(context)
          .pushReplacementNamed('/setPassword', arguments: {"phone": phone});
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
              child: Column(
                children: [
                  const Header(title: '注册'),
                  VerifyPhone(
                    submit: register,
                  )
                ],
              ))),
    );
  }
}
