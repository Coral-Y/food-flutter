import 'package:flutter/material.dart';
import 'package:food/model/exception.dart';
import 'package:food/utils/validate.dart';
import 'package:food/widgets/c_button.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  bool _obscured = true;
  bool agreed = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _phoneController.text = '';
    _passwordController.text = '';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 登录
  void signIn() async {
    String phone = _phoneController.text;
    String password = _passwordController.text;
    if (phone.length != 11 || !isPhone(phone)) {
      CSnackBar(message: '请输入正确的手机号').show(context);
      return;
    }
    if (password.isEmpty || !isPassword(password)) {
      CSnackBar(message: '请输入正确的密码').show(context);
      return;
    }
    if (!agreed) {
      CSnackBar(message: '请同意用户协议和隐私协议').show(context);
      return;
    }

    try {
      await AuthApi().signIn(
        phone,
        password,
      );
      try {
        UserInfo userInfo = await AccountsApi().getUserInfo();
        if (!mounted) return;
        context.read<UserProvider>().setUserInfo(userInfo);
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print("Error loading user info: $e");
        CSnackBar(message: '获取用户信息失败').show(context);
      }
    } on ApiException catch (e) {
      CSnackBar(message: e.message).show(context);
    } catch (e) {}
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
            padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
            child: TextField(
              obscureText: _obscured,
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
                      _obscured = !_obscured;
                    });
                  },
                  icon: _obscured
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
                counterText: "", // 隐藏字符计数器
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: Text(
                    '注册',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColor),
                  ),
                )
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
                onTap: () {
                  Navigator.of(context).pushNamed('/userAgreement');
                },
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
                onTap: () {
                  Navigator.of(context).pushNamed('/privacyPolicy');
                },
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
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 45),
          //   child: Row(
          //     children: [
          //       Expanded(
          //           child: Divider(
          //         color: Color(0xff333333),
          //       )),
          //       Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 4),
          //         child: Text('其他方式登录'),
          //       ),
          //       Expanded(
          //           child: Divider(
          //         color: Color(0xff333333),
          //       )),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 15),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       GestureDetector(
          //         child: Container(
          //           padding: EdgeInsets.all(6),
          //           decoration: BoxDecoration(
          //             border: Border.all(),
          //             shape: BoxShape.circle,
          //           ),
          //           child: const Iconify(
          //             Cib.qq,
          //             color: Colors.blue,
          //           ),
          //         ),
          //       ),
          //       GestureDetector(
          //         child: Container(
          //           padding: EdgeInsets.all(6),
          //           decoration: BoxDecoration(
          //             border: Border.all(),
          //             shape: BoxShape.circle,
          //           ),
          //           child: const Iconify(
          //             Cib.wechat,
          //             color: Colors.green,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      )),
    );
  }
}
