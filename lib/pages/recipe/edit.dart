import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food/model/recipe.dart';
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
  final Recipe recipe = Recipe(name: '', image: '');
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

  _bottomSheet() {
    var kinds = ['水煮牛肉', '拆骨肉荷包蛋', '鸡翅包饭'];
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Column(
              children: [
                // 按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 30,
                      child: CButton(
                        onPressed: () {},
                        text: '删除',
                        type: 'secondary',
                        size: 'small',
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 30,
                      child: CButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: '确认',
                        size: 'small',
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: kinds.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(kinds[index]),
                          );
                        }))
              ],
            ),
          );
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
              const Header(title: '编辑食谱'),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: '名称'),
                      onChanged: (value) {
                        recipe.name = value;
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
                        InkWell(
                          onTap: _bottomSheet,
                          child: Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: const Text('AB'),
                            ),
                            label: const Text('选择分类'),
                          ),
                        )
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
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 25, 40, 25),
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
                                recipe.name = value;
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
                                recipe.name = value;
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
                                recipe.name = value;
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
              ))
            ],
          ),
        ),
      ),
    );
  }
}
