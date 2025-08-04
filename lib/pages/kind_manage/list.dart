import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food/api/icon.dart';
import 'package:food/api/kind.dart';
import 'package:food/config.dart';
import 'package:food/model/common.dart';
import 'package:food/model/exception.dart';
import 'package:food/model/icon.dart';
import 'package:food/model/kind.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/widgets/header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:iconify_flutter/icons/codicon.dart';

class KindManage extends StatefulWidget {
  const KindManage({super.key});

  @override
  State<KindManage> createState() => _KindManageState();
}

class _KindManageState extends State<KindManage> {
  List<Kind> kinds = [];
  bool isLoading = false; // 用于指示数据加载状态
  int current = 1; // 当前页码
  int pageSize = 20;
  int totalPage = 1; // 总页数
  DateTime? _lastFetchTime; //下拉获取更多时间

  //获取分类列表
  Future<void> getKindList() async {
    try {
      var res = await KindApi().list(current: current, pageSize: pageSize);
      print(res);
      setState(() {
        kinds = res.list;
      });
    } catch (e) {}
  }

  // 获取下一页数据
  Future<void> getNextPage() async {
    if (isLoading || current >= totalPage) return;
    setState(() {
      current = current + 1;
    });
    await getKindList();
  }

  //添加
  Future<void> addKind(Kind kind) async {
    print(kind);
    bool isOk = await KindApi().add(kind);
    if (isOk) {
      getKindList();
      CSnackBar(message: '添加成功').show(context);
    } else {
      CSnackBar(message: '添加失败').show(context);
    }
  }

  // 修改计划
  Future<void> updateKind(Kind kind) async {
    print(kind);
    bool isOk = await KindApi().edit(kind);
    if (isOk) {
      final index = kinds.indexWhere((kind) => kind.id == kind.id);
      if (index != -1) {
        setState(() {
          kinds[index] = kind;
        });
      }
      CSnackBar(message: '修改成功').show(context);
    } else {
      CSnackBar(message: '修改失败').show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getKindList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: '分类'),
            FilledButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return PickerBottomSheet(
                      icon: null,
                      name: null,
                      id: null,
                      onAddKind: addKind,
                      onUpdateKind: updateKind,
                    );
                  },
                );
              },
              label: const Text('添加'),
              icon: const Iconify(
                Cil.plus,
                color: Colors.white,
                size: 18,
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                  minimumSize: MaterialStateProperty.all(const Size(25, 30)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsetsDirectional.symmetric(horizontal: 10))),
            ),
            Expanded(
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  ScrollMetrics scrollMetrics = notification.metrics;
                  double pixels = scrollMetrics.pixels;
                  double maxPixels = scrollMetrics.maxScrollExtent;
                  // 滚动超过内容的 2/3
                  if (pixels >= maxPixels / 3 * 2) {
                    final now = DateTime.now();
                    if (_lastFetchTime != null &&
                        now.difference(_lastFetchTime!) <
                            const Duration(seconds: 2)) {
                      return true;
                    }
                    _lastFetchTime = now;
                    if (totalPage > current) {
                      getNextPage();
                    } else {
                      CSnackBar(message: '没有更多').show(context);
                    }
                  }
                  final metrics = notification.metrics;
                  if (metrics.pixels >= metrics.maxScrollExtent - 100) {
                    getNextPage();
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: kinds.length + 1,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Color(0xFF999999)),
                  itemBuilder: (context, index) {
                    if (index == kinds.length) {
                      return isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink();
                    }

                    final kind = kinds[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.network(
                              '$ICON_SERVER_URI${kind.icon}.svg',
                              placeholderBuilder: (context) =>
                                  const CircularProgressIndicator(),
                            ),
                            const SizedBox(width: 4),
                            Text(kind.name,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return PickerBottomSheet(
                                      icon: kind.icon,
                                      name: kind.name,
                                      id: kind.id,
                                      onAddKind: addKind,
                                      onUpdateKind: updateKind,
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Iconify(
                                  Cil.color_border,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("确认删除"),
                                    content: const Text("确定要删除这个分类吗？此操作无法撤销。"),
                                    actions: [
                                      TextButton(
                                        child: const Text("取消"),
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                      TextButton(
                                        child: const Text("删除",
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  try {
                                    await KindApi().delete(kind.id);
                                    kinds.removeAt(index);
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("删除成功")),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("删除失败：$e")),
                                    );
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Iconify(
                                  Cil.trash,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class PickerBottomSheet extends StatefulWidget {
  final String? icon;
  final String? name;
  final int? id;
  final Future<void> Function(Kind) onAddKind;
  final Future<void> Function(Kind) onUpdateKind;
  const PickerBottomSheet({
    Key? key,
    this.icon,
    this.name,
    this.id,
    required this.onAddKind,
    required this.onUpdateKind,
  }) : super(key: key);

  @override
  _PickerBottomSheetState createState() => _PickerBottomSheetState();
}

class _PickerBottomSheetState extends State<PickerBottomSheet> {
  late TextEditingController _nameController;
  String? selectedIcon;
  int _selectedTabIndex = 0; // 添加选项卡索引
  Timer? _debounce; // 用于搜索防抖
  int? recipeId;

  // 加载食谱分页
  int current = 1;
  int totalPage = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  List<String> icons = [];

  Future<void> getIconList() async {
    try {
      Pager<FoodIcon> data = await IconApi().list('dish');
      setState(() {
        icons = data.list.map((icon) => icon.enName).toList();
      });
    } on ApiException catch (e) {
      CSnackBar(message: e.message).show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getIconList();
    _nameController = TextEditingController(text: widget.name ?? '');
    selectedIcon = widget.icon;
  }

  @override
  Widget build(BuildContext context) {
    // 获取键盘的高度
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

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
                  Text(
                    widget.id == null ? '添加分类' : '编辑分类',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 30,
                    child: CButton(
                      onPressed: () {
                        final dish = Kind(
                          id: widget.id == null ? 0 : widget.id!,
                          name: _nameController.text,
                          icon: selectedIcon!,
                        );
                        if (widget.id == null && widget.id != 0) {
                          //添加
                          widget.onAddKind(dish);
                        } else {
                          //修改
                          widget.onUpdateKind(dish);
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
                        label: Text('分类名称'),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: DefaultTabController(
                      initialIndex: _selectedTabIndex,
                      length: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.count(
                              padding: const EdgeInsets.only(top: 10),
                              crossAxisCount: 10,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 8,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIcon = null;
                                      recipeId = null;
                                    });
                                  },
                                  child: const Iconify(
                                    Codicon.circle_slash,
                                    size: 16,
                                  ),
                                ),
                                ...icons.map((item) => GestureDetector(
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
                              ],
                            ),
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
