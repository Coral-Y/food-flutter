import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({super.key});

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          children: [
            Header(title: '个人信息'),
            SizedBox(
              height: 15,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '用户名'),
            ),
          ],
        ),
      )),
    );
  }
}
