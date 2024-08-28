import 'package:flutter/material.dart';
import 'package:food/widgets/c_button.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cib.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool agreed = false;

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
          const Padding(
            padding: EdgeInsets.only(top: 25, left: 15, right: 15),
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                label: Text('手机号'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                label: Text('密码'),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 协议
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
              child: CButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/home');
                  },
                  text: '登录'),
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
