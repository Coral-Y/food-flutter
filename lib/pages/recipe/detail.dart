import 'package:flutter/material.dart';
import 'package:food/model/recipe.dart';
import 'package:food/model/kind.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:food/widgets/header.dart';
import 'package:food/widgets/c_button.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi_light.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:food/pages/recipe/step.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  final Recipe recipe = Recipe(
      id: 1,
      name: '沙拉',
      image: 'assets/images/salad.png',
      kind: Kind(name: '素菜', icon: Twemoji.green_salad),
      ingredients: [
        '生菜',
        '黑椒猪肉肠',
        '鸡蛋'
      ],
      instructions: [
        '把鱿鱼表面清洗干净',
        '热油，放入蒜片和姜片',
        '热油',
        ' 搅拌均匀',
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      title: recipe.name,
                      icon: Iconify(recipe.kind!.icon),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 180,
                                  constraints: const BoxConstraints(
                                    minHeight: 100, // 设置最小高度
                                  ),
                                  color: const Color(0xFFFFFFFE),
                                  child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(4),
                                      padding: const EdgeInsets.fromLTRB(
                                          35, 20, 0, 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              '食材',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ...List.generate(
                                              recipe.ingredients.length,
                                              (index) {
                                            return Text(
                                                recipe.ingredients[index]);
                                          }),
                                        ],
                                      ))),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Container(
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(recipe.image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ...List.generate(recipe.instructions!.length,
                              (index) {
                            return Column(
                              children: [
                                Text(
                                    '${index + 1}. ${recipe.instructions![index]}'),
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
                      onPressed: () {
                        Navigator.of(context).pushNamed('/editRecipe',
                            arguments: {"id": recipe.id});
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                      child: CButton(
                    startIcon: Iconify(MdiLight.play, color: Colors.white),
                    text: "开始制作",
                    onPressed: () {
                      if (recipe.instructions != null &&
                          recipe.instructions!.length > 0) {
                        Navigator.of(context)
                            .pushNamed('/recipeStep', arguments: recipe);
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
