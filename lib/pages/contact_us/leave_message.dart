import 'package:flutter/material.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/header.dart';

class LeaveMessage extends StatefulWidget {
  const LeaveMessage({super.key});

  @override
  State<LeaveMessage> createState() => _LeaveMessageState();
}

class _LeaveMessageState extends State<LeaveMessage> {
  int type = 1;
  String title = '';
  String content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(title: '我要留言'),
              const Text(
                '反馈类型',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Radio(
                      value: 1,
                      groupValue: type,
                      onChanged: (value) => setState(() => type = value ?? 1)),
                  const Text('使用问题'),
                  Radio(
                      value: 2,
                      groupValue: type,
                      onChanged: (value) => setState(() => type = value ?? 1)),
                  const Text('优化建议'),
                  Radio(
                      value: 3,
                      groupValue: type,
                      onChanged: (value) => setState(() => type = value ?? 1)),
                  const Text('新功能需求'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: '标题'),
              ),
              const SizedBox(
                height: 15,
              ),
              const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: '内容'),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: CButton(onPressed: () {}, text: '提交'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
