import 'package:flutter/material.dart';
import 'package:food/api/auth.dart';
import 'package:food/api/accounts.dart';
import 'package:food/widgets/header.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: Column(
            children: [
              const Header(title: '设置'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CButton(
                  onPressed: () async {
                    bool isOk = await AuthApi().logout();
                    if (isOk) {
                      await AccountsApi().clearUserInfo();
                      if (!context.mounted) return;
                      CSnackBar(message: '退出成功').show(context);
                      Navigator.of(context).pushNamed('/login');
                    } else {
                      CSnackBar(message: '退出失败').show(context);
                    }
                  },
                  text: '退出登录',
                  type: 'danger',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
