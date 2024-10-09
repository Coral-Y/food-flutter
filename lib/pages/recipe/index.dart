import 'package:flutter/material.dart';
import 'package:food/model/kind.dart';
import 'package:food/model/recipe.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:food/api/recipe.dart';
import 'package:food/api/kind.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food/config.dart';
import 'package:food/widgets/c_snackbar.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  Kind kind = Kind(id: 0, name: '全部', icon: "meat"); //当前分类
  List<Kind> kinds = [];
  List<Recipe> recipes = []; //食谱列表
  int current = 0; //当前页码
  int totalPage = 0; //总页数

  Future<void> getRecipeList(int page) async {
    try {
      var res = await RecipeApi().list(current: page);
      setState(() {
        current = res.current;
        totalPage = res.totalPage;
        recipes = res.list;
      });
      print('当前页${current}');
      print("获取列表");
    } catch (e) {
      print(e);
    }
  }

  Future<void> getKindList() async {
    try {
      var res = await KindApi().list();
      setState(() {
        Kind all = Kind(id: 0, name: '全部', icon: "meat");
        kinds = res.list;
        kinds.insert(0, all);
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getRecipeList(1);
    getKindList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            width: 150,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Text(
                    '分类',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                        padding:
                            const EdgeInsets.only(top: 20, right: 15, left: 15),
                        itemCount: kinds.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              color: Color(0xFF999999),
                            ),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                kind = kinds[index];
                              });
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.network(
                                  width: 20,
                                  height: 20,
                                  '$ICON_SERVER_URI${kinds[index].icon}.svg',
                                  placeholderBuilder: (BuildContext context) =>
                                      const CircularProgressIndicator(
                                          strokeWidth: 3.0),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  kinds[index].name,
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          );
                        }))
              ],
            ))),
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
                      Builder(builder: (context) {
                        return FilledButton.icon(
                          label: Text(kind.name),
                          icon: const Iconify(
                            Cil.list,
                            color: Colors.white,
                            size: 18,
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4))),
                              minimumSize:
                                  MaterialStateProperty.all(const Size(25, 30)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsetsDirectional.symmetric(
                                      horizontal: 10))),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      }),
                      const SizedBox(
                        width: 5,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/editRecipe',
                              arguments: Recipe(
                                id: 0,
                                name: '',
                                image: '',
                                kind: kind,
                                ingredients: [],
                                seasonings: [],
                                instructions: [],
                              ));
                        },
                        label: const Text('添加'),
                        icon: const Iconify(
                          Cil.plus,
                          color: Colors.white,
                          size: 18,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
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
                child: NotificationListener<ScrollEndNotification>(
                  onNotification: (ScrollNotification notification) {
                    ScrollMetrics scrollMetrics = notification.metrics;
                    double pixels = scrollMetrics.pixels;
                    double maxPixels = scrollMetrics.maxScrollExtent;
                    // 滚动超过内容的2/3
                    if (pixels >= maxPixels / 3 * 2) {
                      if (totalPage > current) {
                        getRecipeList(current + 1); // 加载更多数据
                      } else {
                        CSnackBar(message: '没有更多').show(context);
                      }
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    key: _refreshKey,
                    onRefresh: () => getRecipeList(1), // 下拉刷新数据
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.3,
                        crossAxisCount: 2, // 每行两列
                      ),
                      itemCount: recipes.length, // 显示的条目数
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          name: recipes[index].name,
                          image: recipes[index].image,
                          id: recipes[index].id,
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }
}

class RecipeCard extends StatelessWidget {
  final String name;
  final String image;
  final int id;

  const RecipeCard(
      {super.key, required this.name, required this.image, required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/recipeDetail', arguments: {"id": id});
      },
      child: Card(
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
              padding: EdgeInsets.only(left: 5, bottom: 5),
              child: Text(name),
            )
          ],
        ),
      ),
    );
  }
}
