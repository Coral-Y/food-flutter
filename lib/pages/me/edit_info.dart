import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';
import 'package:image_picker/image_picker.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({super.key});

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  String imagePath = '';
  String nickname = '';
  TextEditingController _nicknameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    imagePath = args['imagePath'];
    nickname = args['nickname'];
    _nicknameController.text = nickname; // 初始化文本框
  }

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _submit() {
    //收起键盘
    FocusScope.of(context).unfocus();
    final nickname = _nicknameController.text;
    if (nickname.isEmpty) {
      CSnackBar(message: '用户名不能为空').show(context);
    } else {
      //TODO:提交请求
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          children: [
            const Header(title: '个人信息'),
            Row(
              children: [
                const Text(
                  '头像',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 25,
                ),
                InkWell(
                    onTap: _pickImage,
                    child: _image == null
                        ? CircleAvatar(
                            radius: 40, // 半径
                            backgroundImage: AssetImage(imagePath))
                        : Image.file(
                            _image!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '用户名'),
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
      )),
    );
  }
}
