import 'package:flutter/material.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/header.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/api/message.dart';

class LeaveMessage extends StatefulWidget {
  const LeaveMessage({super.key});

  @override
  State<LeaveMessage> createState() => _LeaveMessageState();
}

class _LeaveMessageState extends State<LeaveMessage> {
  int type = 1;
  String title = '';
  TextEditingController _titleController = TextEditingController();
  String content = '';
  TextEditingController _contentController = TextEditingController();
  final Map<int, String> typeMap = {
    1: 'issue', // 使用问题
    2: 'recommendation', // 优化建议
    3: 'feature', // 新功能需求
  };

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_titleController.text.isEmpty) {
      CSnackBar(message: '标题不能为空').show(context);
      return;
    }
    if (_contentController.text.isEmpty) {
      CSnackBar(message: '内容不能为空').show(context);
      return;
    } else {
      bool isOk = await MessageApi().create(
        title: _titleController.text,
        type: typeMap[type] ?? 'issue',
        content: _contentController.text,
      );
      if (isOk) {
        CSnackBar(message: '提交成功').show(context);
        Navigator.of(context).pop(true);
      } else {
        CSnackBar(message: '提交失败').show(context);
      }
    }
  }

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
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '反馈类型',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Radio(
                            value: 1,
                            groupValue: type,
                            onChanged: (value) =>
                                setState(() => type = value ?? 1)),
                        const Text('使用问题'),
                        Radio(
                            value: 2,
                            groupValue: type,
                            onChanged: (value) =>
                                setState(() => type = value ?? 1)),
                        const Text('优化建议'),
                        Radio(
                            value: 3,
                            groupValue: type,
                            onChanged: (value) =>
                                setState(() => type = value ?? 1)),
                        const Text('新功能需求'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: '标题'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      maxLines: 4,
                      controller: _contentController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: '内容'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CButton(onPressed: _submit, text: '提交'),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
