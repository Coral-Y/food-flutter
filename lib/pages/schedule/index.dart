import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food/model/dish.dart';
import 'package:food/widgets/c_button.dart';

class WeeklySchedule extends StatefulWidget {
  const WeeklySchedule({super.key});

  @override
  State<WeeklySchedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<WeeklySchedule> {
  final List<String> week = <String>['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  final List<String> types = <String>['早餐', '中餐', '晚餐'];
  DateTime current = DateTime.now();
  List<Dish> breakfast = <Dish>[
    Dish(
        recipeId: 1,
        title: '拆骨肉荷包蛋',
        icon: 'egg',
        type: 1,
        date: DateTime(2024, 8, 27)),
    Dish(
        recipeId: 2,
        title: '牛奶',
        icon: 'milk',
        type: 1,
        date: DateTime(2024, 8, 27)),
    Dish(
        recipeId: 3,
        title: '鸡蛋',
        icon: 'egg',
        type: 1,
        date: DateTime(2024, 8, 27)),
    Dish(
        recipeId: 4,
        title: '牛奶',
        icon: 'milk',
        type: 1,
        date: DateTime(2024, 8, 27)),
  ];

  // 更新当前日期
  void updateCurrent(DateTime newDate) {
    setState(() {
      current = newDate;
    });
    //TODO:请求当前日期数据
    setState(() {
      breakfast = <Dish>[
        Dish(
            recipeId: 1,
            title: '鸡蛋',
            icon: 'egg',
            type: 1,
            date: DateTime(2024, 8, 27)),
        Dish(
            recipeId: 2,
            title: '牛奶',
            icon: 'milk',
            type: 1,
            date: DateTime(2024, 8, 27)),
        Dish(
            recipeId: 3,
            title: '鸡蛋',
            icon: 'egg',
            type: 1,
            date: DateTime(2024, 8, 27)),
        Dish(
            recipeId: 4,
            title: '牛奶',
            icon: 'milk',
            type: 1,
            date: DateTime(2024, 8, 27)),
      ];
    });
  }

  // 修改/添加计划
  Future<void> addOrUpdatePlanning(
      {String? name, String? icon, int? id}) async {
    //TODO:请求添加修改计划
    print(id);
    print(name);
    print(current);
  }

  //删除计划
  Future<void> deletePlanning(id) async {
    //TODO:请求删除计划
    print(id);
    print(current);
  }

  _bottomSheet({String? title, String? icon, String? name, int? id}) {
    print(id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PickerBottomSheet(
            title: title,
            icon: icon,
            name: name,
            id: id,
            onSubmit: addOrUpdatePlanning,
            onDelete: deletePlanning);
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
                    child: const CircleAvatar(
                        radius: 26, // 半径
                        backgroundImage:
                            AssetImage('assets/images/strawberry.png'))),
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
                    foods: breakfast,
                    onEdit: ({title, icon, name, id}) => _bottomSheet(
                        title: title, icon: icon, name: name, id: id)),
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
  final Function({String? title, String? icon, String? name, int? id}) onEdit;

  const FoodCard(
      {super.key,
      required this.title,
      required this.foods,
      required this.onEdit});

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
                  child: GridView.count(
                    padding: const EdgeInsets.only(top: 5),
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    children: foods
                        .map((item) => Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                print('编辑');
                                onEdit(
                                    title: title,
                                    icon: item.icon,
                                    name: item.title,
                                    id: item.recipeId);
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
                                    SvgPicture.asset(
                                      'assets/icons/ingredients/${item.icon}.svg',
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
                                      style: const TextStyle(fontSize: 10),
                                    ))
                                  ],
                                ),
                              ),
                            )))
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
  final Function({String? name, String? icon, int? id}) onSubmit;
  final Function(int id) onDelete;
  const PickerBottomSheet(
      {Key? key,
      this.title,
      this.icon,
      this.name,
      this.id,
      required this.onSubmit,
      required this.onDelete})
      : super(key: key);

  @override
  _PickerBottomSheetState createState() => _PickerBottomSheetState();
}

class _PickerBottomSheetState extends State<PickerBottomSheet> {
  late TextEditingController _nameController;
  String? selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    selectedIcon = widget.icon;
  }

  @override
  Widget build(BuildContext context) {
    var tabs = ['assets/icons/emoji.svg', 'assets/icons/recipe.svg'];
    var recipes = ['水煮牛肉', '拆骨肉荷包蛋', '鸡翅包饭'];
    var icons = ['egg', 'cookie', 'bread', 'peach', 'pear'];

    return Container(
      height: 500,
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
                      // 按钮点击事件
                      widget.onDelete(widget.id!);
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
                    //修改规划
                    widget.onSubmit(
                        name: _nameController.text,
                        icon: selectedIcon,
                        id: widget.id);
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
                SvgPicture.asset(
                  'assets/icons/ingredients/$selectedIcon.svg',
                  width: 40,
                  height: 40,
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
                    labelText: widget.title,
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {
                    // 滚动到输入框位置
                    // FocusScope.of(context).requestFocus(FocusNode());
                  },
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
                  length: 2,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 120,
                          child: TabBar(
                              dividerHeight: 0,
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
                            children: icons
                                .map((item) => GestureDetector(
                                      onTap: () {
                                        print(item);
                                        setState(() {
                                          selectedIcon = item;
                                        }); // 刷新界面以显示选中的图标
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/ingredients/$item.svg',
                                      ),
                                    ))
                                .toList(),
                          ),
                          ListView.builder(
                              itemCount: recipes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(recipes[index]),
                                  onTap: () {
                                    setState(() {
                                      _nameController.text = recipes[index];
                                    });
                                  },
                                );
                              })
                        ]),
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}
