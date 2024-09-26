import 'dart:io';
import 'package:food/model/kind.dart';
import 'package:food/model/recipe.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_list_tile.dart';
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
  final TextEditingController _ingredientController =
      TextEditingController(); //食材输入框控制器
  final FocusNode _ingredientFocusNode = FocusNode(); // 食材 FocusNode
  final TextEditingController _seasoningController =
      TextEditingController(); //调料输入框控制器
  final FocusNode _seasoningFocusNode = FocusNode(); // 调料 FocusNode
  final TextEditingController _instructionController =
      TextEditingController(); //步骤输入框控制器
  final FocusNode _instructionFocusNode = FocusNode(); // 步骤 FocusNode
  final Recipe recipe = Recipe(
    name: '',
    image: '',
  );
  File? _image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (args['kind'].name != '全部') {
      recipe.kind = args['kind'];
    }
  }

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
    final List<Kind> kinds = [
      Kind(name: '荤菜', icon: Twemoji.shallow_pan_of_food),
      Kind(name: '素菜', icon: Twemoji.green_salad),
      Kind(name: '主食', icon: Twemoji.cooked_rice),
      Kind(name: '汤羹', icon: Twemoji.pot_of_food),
    ];
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
                Expanded(
                    child: ListView.separated(
                        padding: const EdgeInsets.only(top: 5),
                        itemCount: kinds.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              color: Color(0xFFf5f5f5),
                            ),
                        itemBuilder: (BuildContext context, int index) {
                          return CListTile(
                            leading: Iconify(kinds[index].icon),
                            title: kinds[index].name,
                            onTap: () {
                              setState(() {
                                recipe.kind = kinds[index];
                              });
                              Navigator.pop(context);
                            },
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      const Text(
                        '名称',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: '请输入名称'),
                          onChanged: (value) {
                            recipe.name = value;
                          },
                        ),
                      )
                    ]),
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
                            avatar: recipe.kind == null
                                ? const CircleAvatar(
                                    backgroundColor: Color(0xfff5f5f5),
                                  )
                                : Iconify(recipe.kind!.icon),
                            label: Text(recipe.kind != null
                                ? recipe.kind!.name
                                : '选择分类'),
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
                                : Container(
                                    width: 160,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.0), // 设置圆角半径
                                      image: DecorationImage(
                                        image: FileImage(_image!), // 替换为你的图片路径
                                        fit: BoxFit.cover, // 控制图片的缩放和裁剪方式
                                      ),
                                    ),
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
                              controller: _ingredientController,
                              focusNode: _ingredientFocusNode,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '请输入食材')),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            if (_ingredientController.text != null &&
                                !_ingredientController.text.isEmpty) {
                              print(_ingredientController.text);
                              setState(() {
                                recipe.ingredients
                                    .add(_ingredientController.text);
                              });
                              _ingredientController.clear();
                            }
                          },
                          child: const Iconify(MdiLight.plus_circle),
                        )
                      ],
                    ),
                    if (recipe.ingredients.isNotEmpty)
                      TagList(
                        tags: recipe.ingredients,
                        onDeleted: (item) {
                          setState(() {
                            recipe.ingredients.remove(item);
                          });
                        },
                        onDoubleTap: (item) {
                          setState(() {
                            print(item);
                            _ingredientController.text = item;
                            recipe.ingredients.remove(item);
                          });
                          _ingredientFocusNode.requestFocus(); // 请求焦点
                        },
                      ),
                    const SizedBox(
                      height: 15,
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
                            controller: _seasoningController,
                            focusNode: _seasoningFocusNode,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '请输入调料'),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            if (_seasoningController.text != null &&
                                !_seasoningController.text.isEmpty) {
                              setState(() {
                                recipe.seasonings ??= [];
                                recipe.seasonings
                                    ?.add(_seasoningController.text);
                              });
                              _seasoningController.clear();
                            }
                          },
                          child: const Iconify(MdiLight.plus_circle),
                        )
                      ],
                    ),
                    if (recipe.seasonings != null)
                      TagList(
                        tags: recipe.seasonings!,
                        onDeleted: (item) {
                          setState(() {
                            recipe.seasonings!.remove(item);
                          });
                        },
                        onDoubleTap: (item) {
                          setState(() {
                            print(item);
                            _seasoningController.text = item;
                            recipe.seasonings!.remove(item);
                          });
                          _seasoningFocusNode.requestFocus(); // 请求焦点
                        },
                      ),
                    const SizedBox(
                      height: 15,
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
                            controller: _instructionController,
                            focusNode: _instructionFocusNode,
                            maxLines: null,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '请输入步骤'),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            if (_instructionController.text.isNotEmpty) {
                              setState(() {
                                recipe.instructions ??= [];
                                recipe.instructions
                                    ?.add(_instructionController.text);
                              });
                              _instructionController.clear();
                            }
                          },
                          child: const Iconify(MdiLight.plus_circle),
                        )
                      ],
                    ),
                    if (recipe.instructions != null)
                      StepList(
                        steps: recipe.instructions!,
                        onDeleted: (index) {
                          setState(() {
                            recipe.instructions!.removeAt(index);
                          });
                        },
                        onDoubleTap: (item) {
                          setState(() {
                            print(item);
                            _instructionController.text = item;
                          });
                          _instructionFocusNode.requestFocus(); // 请求焦点
                        },
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

class TagList extends StatelessWidget {
  final List<String> tags;
  final void Function(String)? onDoubleTap;
  final void Function(String)? onDeleted;
  const TagList(
      {super.key, required this.tags, this.onDeleted, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 4,
        children: tags.map((item) {
          return InkWell(
            onDoubleTap: () {
              if (onDoubleTap != null) {
                onDoubleTap!(item);
              }
            },
            child: Chip(
              label: Text(item),
              labelStyle: TextStyle(color: Color(0xffd4939d)),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xffd4939d), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              deleteIcon: const Iconify(MdiLight.minus_circle,
                  color: Color(0xffd4939d)),
              onDeleted: () {
                onDeleted!(item);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class StepList extends StatelessWidget {
  final List<String> steps;
  final void Function(String)? onDoubleTap;
  final void Function(int)? onDeleted;

  const StepList(
      {super.key, required this.steps, this.onDeleted, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < steps.length; index++)
          Container(
            key: ValueKey(steps[index]),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: InkWell(
              onDoubleTap: () {
                if (onDoubleTap != null) {
                  onDoubleTap!(steps[index]);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('${index + 1}. ${steps[index]}'),
                  ),
                  IconButton(
                    icon: const Iconify(MdiLight.minus_circle),
                    onPressed: () => onDeleted!(index),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
