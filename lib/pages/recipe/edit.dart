import 'dart:io';
import 'package:food/widgets/c_button.dart';
import 'package:iconify_flutter/icons/mdi_light.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:image_picker/image_picker.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe({super.key});

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  final recipe = {"name": ''};
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
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            children: [
              const Header(title: '编辑食谱'),
              const SizedBox(
                height: 15,
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: '名称'),
                onChanged: (value) {
                  setState(() {
                    recipe['name'] = value;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Text(
                    '分类',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: Colors.grey.shade800,
                      child: const Text('AB'),
                    ),
                    label: const Text('Aaron Burr'),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Text(
                    '图标',
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
                              padding: const EdgeInsets.all(10),
                              child: const Iconify(
                                Cil.plus,
                                size: 20,
                              ))
                          : Image.file(
                              _image!,
                              width: 160,
                              height: 90,
                              fit: BoxFit.cover,
                            ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Text(
                    '图片',
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
                              padding:
                                  const EdgeInsets.fromLTRB(40, 25, 40, 25),
                              child: const Iconify(
                                Cil.plus,
                                size: 40,
                              ))
                          : Image.file(
                              _image!,
                              width: 160,
                              height: 90,
                              fit: BoxFit.cover,
                            ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Text(
                    '食材',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          recipe['name'] = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Iconify(MdiLight.plus_circle),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    '调料',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          recipe['name'] = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Iconify(MdiLight.plus_circle),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    '步骤',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          recipe['name'] = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Iconify(MdiLight.plus_circle),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                    child: CButton(
                      onPressed: () {},
                      text: '取消',
                      type: 'secondary',
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: CButton(
                      onPressed: () {},
                      text: '确认',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
