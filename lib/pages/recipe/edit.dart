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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food/config.dart';
import 'package:food/api/kind.dart';
import 'package:food/api/recipe.dart';
import 'package:food/model/exception.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/providers/recipe_provider.dart';
import 'package:provider/provider.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe({super.key});

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  String _title = '新增';
  final TextEditingController _nameController =
      TextEditingController(); //名称输入框控制器
  final TextEditingController _ingredientController =
      TextEditingController(); //食材输入框控制器
  final FocusNode _ingredientFocusNode = FocusNode(); // 食材 FocusNode
  final TextEditingController _seasoningController =
      TextEditingController(); //调料输入框控制器
  final FocusNode _seasoningFocusNode = FocusNode(); // 调料 FocusNode
  final TextEditingController _instructionController =
      TextEditingController(); //步骤输入框控制器
  List<TextEditingController> _stepscontrollers = [];
  Recipe recipe = Recipe(
      id: 0,
      name: '',
      image: '',
      kind: Kind(id: 0, name: '全部', icon: Twemoji.shallow_pan_of_food));
  List<Kind> kinds = []; //分类
  File? _image; //图片文件

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Recipe;
    recipe = args;
    if (args.id != 0) {
      _title = '编辑';
      _nameController.text = recipe.name;
      _stepscontrollers = recipe.instructions!
          .map((instruction) => TextEditingController(text: instruction))
          .toList();
      if (recipe.image.isNotEmpty) {
        recipe.image = IMG_SERVER_URI + recipe.image;
      }
      return;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        recipe.image = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> getKindList() async {
    try {
      var res = await KindApi().list();
      print(res.list);
      setState(() {
        kinds = res.list;
      });
    } catch (e) {}
  }

  Future<void> _handleSubmit() async {
    try {
      if (recipe.id == 0) {
        await _addRecipe();
      } else {
        await _updateRecipe();
      }
      Navigator.of(context).pop(true);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _addRecipe() async {
    await RecipeApi().created(recipe);
    CSnackBar(message: '添加成功').show(context);
  }

  Future<void> _updateRecipe() async {
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    await recipeProvider.updateRecipe(recipe);
    CSnackBar(message: '修改成功').show(context);
  }

  void _handleError(dynamic e) {
    String errorMessage = '操作失败';
    if (e is ApiException) {
      errorMessage = '错误: ${e.message}, 代码: ${e.code}';
    } else {
      errorMessage = '发生未知错误: $e';
    }
    CSnackBar(message: errorMessage).show(context);
  }

  _bottomSheet() async {
    await getKindList();
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
                            leading: SvgPicture.network(
                              '$ICON_SERVER_URI${kinds[index].icon}.svg',
                              placeholderBuilder: (BuildContext context) =>
                                  const CircularProgressIndicator(),
                            ),
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
              Header(title: '$_title食谱'),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
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
                          controller: _nameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: '请输入名称'),
                          onChanged: (value) {
                            recipe.name = value;
                          },
                        ),
                      )
                    ]),
                    const SizedBox(height: 15),
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
                            avatar: recipe.kind!.name == "全部"
                                ? const CircleAvatar(
                                    backgroundColor: Color(0xfff5f5f5),
                                  )
                                : SvgPicture.network(
                                    '$ICON_SERVER_URI${recipe.kind!.icon}.svg',
                                    placeholderBuilder:
                                        (BuildContext context) =>
                                            const CircularProgressIndicator(),
                                  ),
                            label: Text(recipe.kind != null
                                ? recipe.kind!.name
                                : '选择分类'),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
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
                          child: (_image == null &&
                                  (recipe.image == null ||
                                      recipe.image!.isEmpty))
                              ? DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(4),
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 25, 40, 25),
                                  child: const Iconify(
                                    Cil.plus,
                                    size: 40,
                                  ),
                                )
                              : Container(
                                  width: 160,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: _image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                          ))
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            recipe.image!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.error,
                                                    color: Colors.red),
                                              );
                                            },
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
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
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
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
                            maxLines: null,
                            textInputAction: TextInputAction.done,
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
                              final controller = TextEditingController();
                              controller.text = _instructionController.text;
                              setState(() {
                                recipe.instructions ??= [];
                                recipe.instructions
                                    ?.add(_instructionController.text);
                                _stepscontrollers.add(controller); //添加步骤控制器
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
                        stepsController: _stepscontrollers,
                        onDeleted: (index) {
                          setState(() {
                            _stepscontrollers[index].dispose(); // 释放步骤控制器
                            _stepscontrollers.removeAt(index); // 移除步骤控制器
                            recipe.instructions!.removeAt(index);
                          });
                        },
                        onChanged: (index, value) {
                          setState(() {
                            recipe.instructions![index] = value; // 更新步骤内容
                          });
                        },
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              )),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
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
                      Expanded(
                          child: CButton(onPressed: _handleSubmit, text: '确认')),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 释放所有控制器
    _ingredientController.dispose();
    _ingredientFocusNode.dispose();
    _seasoningController.dispose();
    _seasoningFocusNode.dispose();
    _instructionController.dispose();
    for (var controller in _stepscontrollers) {
      controller.dispose();
    }
    super.dispose();
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
              labelStyle: const TextStyle(color: Color(0xffd4939d)),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffd4939d), width: 1),
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

class StepList extends StatefulWidget {
  final List<String> steps;
  final List<TextEditingController> stepsController;
  final void Function(int)? onDeleted;
  final Function(int, String) onChanged;

  const StepList({
    super.key,
    required this.steps,
    required this.stepsController,
    this.onDeleted,
    required this.onChanged,
  });

  @override
  State<StepList> createState() => _StepListState();
}

class _StepListState extends State<StepList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < widget.steps.length; index++)
          Container(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${index + 1}. '),
                  Expanded(
                    child: TextField(
                      controller: widget.stepsController[index],
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: '请输入步骤 ${index + 1}',
                        border: InputBorder.none,
                      ),
                      onEditingComplete: () {
                        widget.onChanged(
                            index, widget.stepsController[index].text);
                      },
                    ),
                  ),
                  IconButton(
                      icon: const Iconify(MdiLight.minus_circle),
                      onPressed: () {
                        widget.onDeleted!(index);
                      }),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
