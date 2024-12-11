import 'dart:io';
import 'package:food/config.dart';
import 'package:food/model/exception.dart';
import 'package:food/model/user_info.dart';
import 'package:food/providers/user_provider.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food/api/accounts.dart';
import 'package:provider/provider.dart';

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
    final userInfo = context.watch<UserProvider>().userInfo;
    if (userInfo != null) {
      imagePath =
          userInfo.avatar.isNotEmpty ? IMG_SERVER_URI + userInfo.avatar : '';
      nickname = userInfo.name;
    }
    _nicknameController.text = nickname;
  }

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_nicknameController.text.isEmpty) {
      CSnackBar(message: '请输入用户名').show(context);
      return;
    } else {
      try {
        await AccountsApi().updateUserInfo(
            name: _nicknameController.text, avatarPath: imagePath);

        context.read<UserProvider>().clearUserInfo();
        UserInfo info = await AccountsApi().getUserInfo();
        context.read<UserProvider>().setUserInfo(info);
        CSnackBar(message: '修改成功').show(context);
        Navigator.of(context).pop();
      } on ApiException catch (e) {
        CSnackBar(message: '修改失败').show(context);
      }
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
                            backgroundColor: Colors.transparent,
                            radius: 40,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(40), // 与 radius 相同的值
                              child: imagePath.isEmpty
                                  ? Image.asset(
                                      'assets/icons/cookie_color.png', // 默认头像图片
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      imagePath,
                                      width: 80, // radius * 2
                                      height: 80, // radius * 2
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.error,
                                              color: Colors.red),
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(40), // 与 radius 相同的值
                            child: Image.file(
                              _image!,
                              width: 80, // radius * 2
                              height: 80, // radius * 2
                              fit: BoxFit.cover,
                            ),
                          ))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: '用户名'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: CButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: '取消',
                    type: 'secondary',
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(child: CButton(onPressed: _submit, text: '确认')),
              ],
            ),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose(); // 销毁控制器
    super.dispose();
  }
}
