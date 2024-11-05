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
import 'package:food/providers/recipe_provider.dart';
import 'package:provider/provider.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  Kind kind = Kind(id: 0, name: '全部', icon: "meat"); //当前分类
  List<Kind> kinds = [];
  bool isDeleteMode = false; // 删除模式标志

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecipeProvider>(context, listen: false).getRecipeList(1, 0);
    });
    getKindList();
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    return Scaffold(
        //分类列表
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
                              recipeProvider.getRecipeList(1, kind.id);
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
            child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Column(
                children: [
                  // 顶部操作栏
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
                                          borderRadius:
                                              BorderRadius.circular(4))),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(25, 30)),
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
                            onPressed: () async {
                              final result =
                                  await Navigator.of(context).pushNamed(
                                '/editRecipe',
                                arguments: Recipe(
                                  id: 0,
                                  name: '',
                                  image: '',
                                  kind: kind,
                                  ingredients: [],
                                  seasonings: [],
                                  instructions: [],
                                ),
                              );
                              if (result == true) {
                                recipeProvider.getRecipeList(1, kind.id);
                              }
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
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(25, 30)),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsetsDirectional.symmetric(
                                        horizontal: 10))),
                          ),
                        ],
                      ),
                      const Text(
                        '我的食谱',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                          if (recipeProvider.totalPage >
                              recipeProvider.current) {
                            recipeProvider.getNextPage(kind.id); // 加载更多数据
                          } else {
                            CSnackBar(message: '没有更多').show(context);
                          }
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        key: _refreshKey,
                        onRefresh: () =>
                            recipeProvider.getRecipeList(1, kind.id), // 下拉刷新数据
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.3,
                            crossAxisCount: 2, // 每行两列
                          ),
                          itemCount: recipeProvider.recipes.length, // 显示的条目数
                          itemBuilder: (context, index) {
                            return Draggable<Recipe>(
                              data: recipeProvider.recipes[index],
                              feedback: Material(
                                color: Colors.transparent,
                                child: Transform.scale(
                                  scale: 0.8, // 缩小到原来的80%
                                  child: Opacity(
                                    opacity: 0.5, // 50%的透明度
                                    child: RecipeCard(
                                      name: recipeProvider.recipes[index].name,
                                      image:
                                          recipeProvider.recipes[index].image,
                                      id: recipeProvider.recipes[index].id,
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: Container(), // 拖动时不显示原始卡片
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/recipeDetail', arguments: {
                                    "id": recipeProvider.recipes[index].id
                                  });
                                },
                                child: RecipeCard(
                                  name: recipeProvider.recipes[index].name,
                                  image: recipeProvider.recipes[index].image,
                                  id: recipeProvider.recipes[index].id,
                                ),
                              ),
                              onDragStarted: () {
                                setState(() {
                                  isDeleteMode = true;
                                });
                              },
                              onDragEnd: (DraggableDetails draggableDetails) {
                                setState(() {
                                  isDeleteMode = false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isDeleteMode)
              Positioned(
                bottom: 20, // 距离底部20像素
                right: 0,
                width: 150,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: DragTarget<Recipe>(
                    onAcceptWithDetails: (recipe) async {
                      bool isDelete =
                          await recipeProvider.deleteRecipe(recipe.data.id);
                      setState(() {
                        isDeleteMode = false;
                      });
                      CSnackBar(message: isDelete == true ? '删除成功' : '删除失败')
                          .show(context);
                    },
                    onWillAccept: (data) => data != null,
                    builder: (context, candidateData, rejectedData) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white, size: 30),
                            SizedBox(height: 8),
                            Text(
                              '删除',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
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
            width: MediaQuery.of(context).size.width / 2 - 20,
            height: 92, // 设置容器高度
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0), // 左上角圆角
                topRight: Radius.circular(10.0), // 右上角圆角
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Image.network(
                IMG_SERVER_URI + image, // URL
                fit: BoxFit.cover, // 图片覆盖整个容器
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, bottom: 5),
            child: Text(name),
          )
        ],
      ),
    );
  }
}
