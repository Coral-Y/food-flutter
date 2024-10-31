import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food/model/dish.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:reorderables/reorderables.dart';
import 'package:food/api/icon.dart';
import 'package:food/model/common.dart';
import 'package:food/model/icon.dart';
import 'package:food/config.dart';
import 'package:food/model/exception.dart';
import 'package:food/api/schedules.dart';
import 'package:food/model/recipe.dart';
import 'package:food/api/recipe.dart';
import 'package:food/config.dart';
import 'package:provider/provider.dart';
import 'package:food/providers/user_provider.dart';

class WeeklySchedule extends StatefulWidget {
  const WeeklySchedule({super.key});

  @override
  State<WeeklySchedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<WeeklySchedule> {
  final List<String> week = <String>['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  final List<String> types = <String>['早餐', '中餐', '晚餐'];
  DateTime current = DateTime.now();
  Map<String, List<Dish>> schedules = {
    'breakfast': [],
    'lunch': [],
    'dinner': [],
  };
  List<String> icons = [];
  String imagePath = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    try {
      _getUserInfo();
      getIconList();
      getScheduleData(DateTime.now());
    } catch (e) {
      if (e is ApiException) {
        print("错误码 ： ${e.code}, 错误 ：  ${e.message}");
      } else {
        print("其他错误: $e");
      }
    }
  }

  //获取用户信息
  Future<void> _getUserInfo() async {
    final userInfo = context.watch<UserProvider>().userInfo;
    if (userInfo != null) {
      setState(() {
        imagePath =
            userInfo.avatar.isNotEmpty ? IMG_SERVER_URI + userInfo.avatar : '';
        print(imagePath);
      });
    }
  }

  // 获取规划列表
  Future<void> getScheduleData(DateTime date) async {
    try {
      var data = await SchedulesApi().getSchedules(date);
      setState(() {
        schedules = data;
        print(schedules);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  // 获取图标列表
  Future<void> getIconList() async {
    Pager<FoodIcon> data = await IconApi().list('dish');
    setState(() {
      icons = data.list.map((icon) => icon.enName).toList();
    });
  }

  // 更新当前日期
  void updateCurrent(DateTime newDate) {
    setState(() {
      current = newDate;
    });
    getScheduleData(current);
  }

  // 获取指定类型的菜品列表
  List<Dish> getMealList(String type) {
    String serverType = type == '早餐'
        ? 'breakfast'
        : type == '中餐'
            ? 'lunch'
            : 'dinner';
    return schedules[serverType] ?? [];
  }

  // 添加计划
  Future<void> addPlan(Dish dish) async {
    bool isOk = await SchedulesApi().addSchedule(dish);
    if (isOk) {
      getScheduleData(current);
      CSnackBar(message: '添加成功').show(context);
    } else {
      CSnackBar(message: '添加失败').show(context);
    }
  }

  // 修改计划
  Future<void> updatePlan(Dish dish) async {
    bool isOk = await SchedulesApi().updateSchedule(dish);
    if (isOk) {
      getScheduleData(current);
      CSnackBar(message: '修改成功').show(context);
    } else {
      CSnackBar(message: '修改失败').show(context);
    }
  }

  //删除计划
  Future<void> deletePlan(id) async {
    bool isOk = await SchedulesApi().deletSchedule(id);
    if (isOk) {
      getScheduleData(current);
      CSnackBar(message: '删除成功').show(context);
    } else {
      CSnackBar(message: '删除失败').show(context);
    }
  }

  _bottomSheet(
      {String? title, String? icon, String? name, int? id, int? recipeId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PickerBottomSheet(
            title: title,
            icon: icon,
            name: name,
            id: id,
            recipeId: recipeId,
            current: current,
            icons: icons,
            onAddPlan: addPlan,
            onUpdatePlan: updatePlan,
            onDelete: deletePlan);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          // 头部背景及用户头像展示
          Stack(
            children: [
              Image.asset(
                'assets/images/food.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 60,
                left: 30,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/me');
                  },
                  child: CircleAvatar(
                    radius: 25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: imagePath.isEmpty
                          ? Image.asset(
                              'assets/icons/cookie_color.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/avatar.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
          // 滚动日期选择
          Container(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            padding: const EdgeInsets.fromLTRB(5, 6, 5, 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: week
                        .map((item) => Container(
                              width: 30,
                              alignment: Alignment.center,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList()),
                const SizedBox(
                  height: 8,
                ),
                DatePicker(
                  current: current,
                  onCurrentUpdate: updateCurrent,
                )
              ],
            ),
          ),

          // 三餐展示
          Expanded(
              child: ListView.builder(
            itemCount: types.length,
            padding: const EdgeInsets.only(top: 15),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _bottomSheet(title: types[index]);
                  });
                },
                child: FoodCard(
                    title: types[index],
                    foods: getMealList(types[index]),
                    onEdit: ({title, icon, name, id, recipeId}) => _bottomSheet(
                        title: title,
                        icon: icon,
                        name: name,
                        id: id,
                        recipeId: recipeId),
                    onReorder: (oldIndex, newIndex) async {
                      var dishes = getMealList(types[index]);
                      var newDishes = List<Dish>.from(dishes);
                      final item = newDishes.removeAt(oldIndex);
                      newDishes.insert(newIndex, item);
                      setState(() {
                        // 更新本地数据
                        if (types[index] == '早餐') {
                          schedules['breakfast'] = newDishes;
                        } else if (types[index] == '中餐') {
                          schedules['lunch'] = newDishes;
                        } else {
                          schedules['dinner'] = newDishes;
                        }
                      });
                      // 获取排序后的 id 列表
                      List<int> dishIds =
                          newDishes.map((dish) => dish.id).toList();
                      bool isOk = await SchedulesApi().updateSchedules(dishIds);
                      if (isOk) {
                        CSnackBar(message: '排序更新成功').show(context);
                      } else {
                        getScheduleData(current);
                        CSnackBar(message: '排序更新失败').show(context);
                      }
                    }),
              );
            },
          ))
        ],
      )),
    );
  }
}

class DatePicker extends StatefulWidget {
  final DateTime current;
  final Function(DateTime) onCurrentUpdate;
  const DatePicker(
      {super.key, required this.current, required this.onCurrentUpdate});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime startOfWeek;
  late List<DateTime> weeks = [];
  PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    setState(() {
      startOfWeek =
          widget.current.subtract(Duration(days: widget.current.weekday - 1));
      weeks = [
        startOfWeek.subtract(const Duration(days: 7)),
        startOfWeek,
        startOfWeek.add(const Duration(days: 7))
      ];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            var first = weeks[0];
            var last = weeks[weeks.length - 1];
            // 如果是第一页
            if (page == 0) {
              setState(() {
                weeks.insert(0, first.subtract(Duration(days: 7)));
                _pageController.jumpToPage(1);
              });
              print('page$weeks');
            }
            // 如果是最后一页
            if (page == weeks.length - 1) {
              setState(() {
                weeks.add(last.add(Duration(days: 7)));
              });
            }
          },
          children: weeks
              .map((item) => WeekView(
                    start: item,
                    current: widget.current,
                    onCurrentUpdate: widget.onCurrentUpdate,
                  ))
              .toList()),
    );
  }
}

class WeekView extends StatelessWidget {
  final DateTime start; // 周一的日期
  final DateTime current; // 当前选中的日期
  final Function(DateTime) onCurrentUpdate; // 更新选中日期回调函数
  const WeekView(
      {super.key,
      required this.start,
      required this.current,
      required this.onCurrentUpdate});

  @override
  Widget build(BuildContext context) {
    List<DateTime> list =
        List.generate(7, (index) => start.add(Duration(days: index)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list
          .map((item) => GestureDetector(
              onTap: () {
                onCurrentUpdate(item);
              },
              child: Container(
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: item.day == current.day &&
                            item.month == current.month &&
                            item.year == current.year
                        ? const Color(0xFFd4939d)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  item.day == 1 ? '${item.month}/${item.day}' : '${item.day}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )))
          .toList(),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String title;
  final List<Dish> foods;
  final Function(
      {String? title,
      String? icon,
      String? name,
      int? id,
      int? recipeId}) onEdit;
  final Function(int oldIndex, int newIndex) onReorder;

  const FoodCard(
      {super.key,
      required this.title,
      required this.foods,
      required this.onEdit,
      required this.onReorder});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ReorderableWrap(
                    padding: const EdgeInsets.only(top: 5),
                    spacing: 30.0, //列间距
                    runSpacing: 20.0, //行间距
                    onReorder: onReorder, //重排序
                    children: foods
                        .map(
                          (item) => InkWell(
                            onTap: () {
                              onEdit(
                                  title: title,
                                  icon: item.icon,
                                  name: item.title,
                                  id: item.id,
                                  recipeId: item.recipeId);
                            },
                            child: Container(
                              width: 100,
                              height: 25,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xFF999999)),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  SvgPicture.network(
                                    '$ICON_SERVER_URI${item.icon}.svg',
                                    width: 13,
                                    height: 13,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                      child: Text(
                                    item.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 12),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class PickerBottomSheet extends StatefulWidget {
  final String? title;
  final String? icon;
  final String? name;
  final int? id;
  final int? recipeId;
  final DateTime current;
  final Function(Dish) onAddPlan;
  final Function(Dish) onUpdatePlan;
  final Function(int id) onDelete;
  final List<String> icons;
  const PickerBottomSheet(
      {Key? key,
      this.title,
      this.icon,
      this.name,
      this.id,
      this.recipeId,
      required this.current,
      required this.onAddPlan,
      required this.icons,
      required this.onUpdatePlan,
      required this.onDelete})
      : super(key: key);

  @override
  _PickerBottomSheetState createState() => _PickerBottomSheetState();
}

class _PickerBottomSheetState extends State<PickerBottomSheet> {
  late TextEditingController _nameController;
  String? selectedIcon;
  List<Recipe> recipes = []; //食谱列表
  int _selectedTabIndex = 0; // 添加选项卡索引
  Timer? _debounce; // 用于搜索防抖
  int? recipeId;

  // 加载食谱分页
  int current = 1;
  int totalPage = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    selectedIcon = widget.icon;
    //TODO：查看是否有recipeId
    widget.recipeId != null ? _selectedTabIndex = 1 : _selectedTabIndex = 0;
    recipeId = widget.recipeId;
    // 添加滚动监听
    _scrollController.addListener(_onScroll);
    getRecipeList();
  }

  //获取账号食谱列表
  Future<void> getRecipeList({String? keyword}) async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await RecipeApi().list(current: 1, keyword: keyword);
      setState(() {
        recipes = res.list;
        current = res.current;
        totalPage = res.totalPage;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 搜索食谱
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getRecipeList(keyword: query);
    });
  }

  // 滚动监听函数
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }

  // 加载更多
  Future<void> _loadMore({String? keyword}) async {
    if (isLoading || current >= totalPage) return;
    setState(() {
      isLoading = true;
    });
    try {
      var res = await RecipeApi().list(current: current + 1, keyword: keyword);
      setState(() {
        current = res.current;
        totalPage = res.totalPage;
        recipes.addAll(res.list);
      });
    } catch (e) {
      print('Error loading more recipes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取键盘的高度
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    var tabs = ['assets/icons/emoji.svg', 'assets/icons/recipe.svg'];

    return Padding(
        padding: EdgeInsets.only(
          bottom: keyboardHeight, // 当键盘弹出时，BottomSheet会跟着上移
        ),
        child: Container(
          height: 300, //默认高度
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Column(
            children: [
              // 按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.name != null && widget.name!.isNotEmpty) ...[
                    SizedBox(
                      width: 60,
                      height: 30,
                      child: CButton(
                        onPressed: () {
                          widget.onDelete(widget.id!);
                          Navigator.pop(context);
                        },
                        text: '删除',
                        type: 'secondary',
                        size: 'small',
                      ),
                    ),
                  ] else ...[
                    SizedBox(width: 60),
                  ],
                  SizedBox(
                    width: 60,
                    height: 30,
                    child: CButton(
                      onPressed: () {
                        final dish = Dish(
                            id: widget.id == null ? 0 : widget.id!,
                            title: _nameController.text,
                            icon: selectedIcon!,
                            type: widget.title == '早餐'
                                ? 'breakfast'
                                : widget.title == '中餐'
                                    ? 'lunch'
                                    : 'dinner',
                            date: widget.current,
                            recipeId: recipeId);
                        if (widget.id == null && widget.id != 0) {
                          //添加
                          widget.onAddPlan(dish);
                        } else {
                          //修改
                          widget.onUpdatePlan(dish);
                        }
                        Navigator.pop(context);
                      },
                      text: '确认',
                      size: 'small',
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // 输入框
              Row(
                children: [
                  if (selectedIcon != null && selectedIcon!.isNotEmpty) ...[
                    SvgPicture.network(
                      '$ICON_SERVER_URI$selectedIcon.svg',
                      width: 40,
                      height: 40,
                      placeholderBuilder: (BuildContext context) =>
                          const CircularProgressIndicator(),
                    )
                  ] else ...[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        label: Text(widget.title!),
                        border: OutlineInputBorder(),
                        hintText: '${widget.title}准备吃...',
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Tab
              Expanded(
                  child: DefaultTabController(
                      initialIndex: _selectedTabIndex,
                      length: 2,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 120,
                              child: TabBar(
                                  dividerHeight: 0,
                                  onTap: (index) {
                                    setState(() {
                                      _selectedTabIndex = index;
                                    });
                                  },
                                  tabs: tabs
                                      .map((item) => Tab(
                                            icon: SvgPicture.asset(
                                              item,
                                              width: 25,
                                              height: 25,
                                            ),
                                          ))
                                      .toList()),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(children: [
                              GridView.count(
                                padding: const EdgeInsets.only(top: 10),
                                crossAxisCount: 10,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 8,
                                children: widget.icons
                                    .map((item) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIcon = item;
                                              recipeId = null;
                                            });
                                          },
                                          child: SvgPicture.network(
                                            '$ICON_SERVER_URI$item.svg',
                                            placeholderBuilder: (BuildContext
                                                    context) =>
                                                const CircularProgressIndicator(),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              ListView.builder(
                                controller: _scrollController,
                                itemCount: recipes.length + 1, // 增加1用于显示加载状态
                                itemBuilder: (context, index) {
                                  if (index == recipes.length) {
                                    // 显示加载状态
                                    return isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : current >= totalPage
                                            ? const Center(
                                                child: Text('没有更多数据了'))
                                            : const SizedBox();
                                  }
                                  final recipe = recipes[index];
                                  return ListTile(
                                    leading: SvgPicture.network(
                                      '$ICON_SERVER_URI${recipe.kindIcon}.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    title: Text(recipe.name),
                                    onTap: () {
                                      setState(() {
                                        _nameController.text = recipe.name;
                                        selectedIcon = recipe.kindIcon;
                                        recipeId = recipe.id;
                                      });
                                    },
                                  );
                                },
                              )
                            ]),
                          )
                        ],
                      )))
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
