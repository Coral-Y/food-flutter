import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:food/widgets/c_button.dart';
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
                        ? DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(4),
                            padding: const EdgeInsets.all(30),
                            child: const Iconify(
                              Cil.plus,
                              size: 40,
                            ))
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
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '用户名'),
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
      )),
    );
  }
}
