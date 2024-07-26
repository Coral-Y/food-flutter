import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final List<Recipe> recipes = [
    Recipe('沙拉', 'assets/images/salad.png'),
    Recipe('汉堡', 'assets/images/hamburger.png')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Column(
        children: [
          // 操作栏
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FilledButton.icon(
                    label: const Text('全部'),
                    icon: const Iconify(
                      Cil.list,
                      color: Colors.white,
                      size: 18,
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                        minimumSize:
                            MaterialStateProperty.all(const Size(25, 30)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsetsDirectional.symmetric(
                                horizontal: 10))),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    label: const Text('添加'),
                    icon: const Iconify(
                      Cil.plus,
                      color: Colors.white,
                      size: 18,
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                        minimumSize:
                            MaterialStateProperty.all(const Size(25, 30)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsetsDirectional.symmetric(
                                horizontal: 10))),
                  ),
                ],
              ),
              const Text(
                '我的食谱',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          ),

          // 食谱列表
          Expanded(
              child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.3,
              crossAxisCount: 2, // 每行两列
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return RecipeCard(
                name: recipes[index].name,
                image: recipes[index].image,
              );
            },
          ))
        ],
      ),
    )));
  }
}

class RecipeCard extends StatelessWidget {
  final String name;
  final String image;
  const RecipeCard({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // 去除阴影
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xFF333333), // 边框颜色
          width: 1, // 边框宽度
        ),
        borderRadius: BorderRadius.circular(10), // 圆角半径
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            height: 92, // 设置容器高度
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0), // 左上角圆角
                topRight: Radius.circular(10.0), // 右上角圆角
              ),
              image: DecorationImage(
                image: AssetImage(image), // 替换为你的图片路径
                fit: BoxFit.cover, // 确保图片覆盖整个容器
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5,bottom: 5),
            child: Text(name),
          )
        ],
      ),
    );
  }
}

class Recipe {
  String name;
  String image;

  Recipe(this.name, this.image);
}
