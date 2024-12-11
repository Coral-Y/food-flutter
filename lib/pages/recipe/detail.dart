import 'package:flutter/material.dart';
import 'package:food/model/recipe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/widgets/header.dart';
import 'package:food/widgets/c_button.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi_light.dart';
import 'package:food/api/recipe.dart';
import 'package:food/config.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  Recipe? recipe;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    getRecipeDetial();
  }

  Future<void> getRecipeDetial() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    try {
      var res = await RecipeApi().detail(args['id']);
      print(res);
      setState(() {
        recipe = res;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recipe == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // 加载中
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      title: recipe!.name,
                      icon: recipe!.kind!.icon,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: recipe!.seasonings!.isNotEmpty ||
                                    recipe!.ingredients!.isNotEmpty,
                                child: Container(
                                    width: 180,
                                    constraints: const BoxConstraints(
                                      minHeight: 100, // 设置最小高度
                                    ),
                                    padding: const EdgeInsets.only(right: 20),
                                    color: const Color(0xFFFFFFFE),
                                    child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(4),
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible: recipe!
                                                  .ingredients!.isNotEmpty,
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  '食材',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            ...List.generate(
                                                recipe!.ingredients!.length,
                                                (index) {
                                              return Text(
                                                  recipe!.ingredients![index]);
                                            }),
                                            Visibility(
                                                visible: recipe!
                                                    .seasonings!.isNotEmpty,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10, bottom: 5),
                                                      child: Text(
                                                        '调料',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    ...List.generate(
                                                        recipe!.seasonings!
                                                            .length, (index) {
                                                      return Text(recipe!
                                                          .seasonings![index]);
                                                    }),
                                                  ],
                                                )),
                                          ],
                                        ))),
                              ),
                              Expanded(
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: recipe!.seasonings!.isNotEmpty ||
                                              recipe!.ingredients!.isNotEmpty
                                          ? 100
                                          : 300,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          IMG_SERVER_URI + recipe!.image,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
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
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Container(
                                              color: Colors.grey[300],
                                              child: Icon(Icons.error,
                                                  color: Colors.red),
                                            );
                                          },
                                        ),
                                      )))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ...List.generate(recipe!.instructions!.length,
                              (index) {
                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft, // 将文本对齐到左侧
                                  child: Text(
                                      '${index + 1}. ${recipe!.instructions![index]}'),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          }),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CButton(
                      startIcon: Iconify(MdiLight.pencil, color: Colors.white),
                      text: "编辑",
                      type: 'secondary',
                      onPressed: () async {
                        final result = await Navigator.of(context)
                            .pushNamed('/editRecipe', arguments: recipe);
                        if (result == true) {
                          getRecipeDetial();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                      child: CButton(
                    startIcon:
                        const Iconify(MdiLight.play, color: Colors.white),
                    text: "开始制作",
                    onPressed: () {
                      if (recipe!.instructions != null &&
                          recipe!.instructions!.isNotEmpty) {
                        Navigator.of(context)
                            .pushNamed('/recipeStep', arguments: recipe);
                      } else {
                        CSnackBar(message: '先添加食谱步骤哦').show(context);
                      }
                      //提示添加步骤
                    },
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
