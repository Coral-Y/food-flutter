import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';
import 'package:food/model/fridge_stock.dart' as model;
import 'package:food/api/fridge_stock.dart';
import 'package:food/widgets/c_snackbar.dart';

class FridgeStock extends StatefulWidget {
  const FridgeStock({super.key});

  @override
  State<FridgeStock> createState() => _FridgeStockState();
}

class _FridgeStockState extends State<FridgeStock> {
  List<model.FridgeStock> refrigeratedItems = []; // 冷藏区
  List<model.FridgeStock> frozenItems = []; // 冷冻区

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 加载数据
  Future<void> _loadData() async {
    try {
      var items = await FridgeStockApi().list();
      print(items);
      setState(() {
        refrigeratedItems =
            items.where((item) => item.location == 'refrigerated').toList();
        frozenItems = items.where((item) => item.location == 'frozen').toList();
      });
    } catch (e) {
      if (mounted) {
        CSnackBar(message: '加载失败: $e').show(context);
      }
    }
  }

  // 添加库存
  Future<void> _addStock(model.FridgeStock stock) async {
    bool isOk = await FridgeStockApi().add(stock);
    if (isOk) {
      _loadData();
      if (mounted) {
        CSnackBar(message: '添加成功').show(context);
      }
    } else {
      if (mounted) {
        CSnackBar(message: '添加失败').show(context);
      }
    }
  }

  // 更新库存
  Future<void> _updateStock(model.FridgeStock stock) async {
    bool isOk = await FridgeStockApi().update(stock);
    if (isOk) {
      _loadData();
      if (mounted) {
        CSnackBar(message: '修改成功').show(context);
      }
    } else {
      if (mounted) {
        CSnackBar(message: '修改失败').show(context);
      }
    }
  }

  // 删除库存
  Future<void> _deleteStock(int id) async {
    bool isOk = await FridgeStockApi().delete(id);
    if (isOk) {
      _loadData();
      if (mounted) {
        CSnackBar(message: '删除成功').show(context);
      }
    } else {
      if (mounted) {
        CSnackBar(message: '删除失败').show(context);
      }
    }
  }

  // 显示底部弹窗
  void _showBottomSheet({model.FridgeStock? stock, required String location}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StockBottomSheet(
          stock: stock,
          location: location,
          onAdd: _addStock,
          onUpdate: _updateStock,
          onDelete: _deleteStock,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 显示选择冷藏或冷冻的对话框
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('添加食材'),
              content: const Text('请选择存储区域'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showBottomSheet(location: 'refrigerated');
                  },
                  child: const Text('冷藏'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showBottomSheet(location: 'frozen');
                  },
                  child: const Text('冷冻'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            children: [
              const Header(title: '我的冰箱'),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // 冷藏区域
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              children: refrigeratedItems
                                  .map((item) => StockItem(
                                        stock: item,
                                        onTap: () => _showBottomSheet(
                                            stock: item,
                                            location: 'refrigerated'),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      )),
                      // 虚线分隔
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '冷藏区',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            CustomPaint(
                              painter: DashedLinePainter(),
                              size: const Size(double.infinity, 1),
                            ),
                            const Text(
                              '冷冻区',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 冷冻区域
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              children: frozenItems
                                  .map((item) => StockItem(
                                        stock: item,
                                        onTap: () => _showBottomSheet(
                                            stock: item, location: 'frozen'),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 虚线绘制类
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// 库存项组件
class StockItem extends StatelessWidget {
  final model.FridgeStock stock;
  final VoidCallback onTap;

  const StockItem({
    super.key,
    required this.stock,
    required this.onTap,
  });

  // 计算剩余天数
  int get remainingDays {
    final now = DateTime.now();
    final expiryDate = stock.purchaseDate.add(Duration(days: stock.shelfLife));
    return expiryDate.difference(now).inDays;
  }

  // 获取状态颜色
  Color get statusColor {
    if (remainingDays <= 0) return Colors.red;
    if (remainingDays <= 3) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    // 根据类型设置边框颜色：冷藏-粉色，冷冻-蓝色
    Color color = stock.location == 'refrigerated'
        ? const Color(0xffd4939d)
        : const Color(0xff232946);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stock.name,
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${stock.count ?? 0} ${stock.unit}',
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 14,
              height: 14,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 圆环进度条
                  CircularProgressIndicator(
                    value: remainingDays <= 0
                        ? 0
                        : (remainingDays / stock.shelfLife).clamp(0.0, 1.0),
                    strokeWidth: 2,
                    backgroundColor: Colors.grey[100]!,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      remainingDays <= 0 ? Colors.white : color,
                    ),
                  ),
                  // 中心文字
                  // Text(
                  //   remainingDays <= 0
                  //       ? '!'
                  //       : '${((remainingDays / stock.shelfLife) * 100).round()}',
                  //   style: TextStyle(
                  //     fontSize: 8,
                  //     color: color,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 底部弹窗组件
class StockBottomSheet extends StatefulWidget {
  final model.FridgeStock? stock;
  final String location;
  final Function(model.FridgeStock) onAdd;
  final Function(model.FridgeStock) onUpdate;
  final Function(int) onDelete;

  const StockBottomSheet({
    super.key,
    this.stock,
    required this.location,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<StockBottomSheet> createState() => _StockBottomSheetState();
}

class _StockBottomSheetState extends State<StockBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _countController;
  late TextEditingController _unitController;
  late TextEditingController _shelfLifeController;
  late DateTime _purchaseDate;
  late String _selectedLocation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.stock?.name ?? '');
    _countController =
        TextEditingController(text: widget.stock?.count?.toString() ?? '');
    _unitController = TextEditingController(text: widget.stock?.unit ?? '个');
    _shelfLifeController =
        TextEditingController(text: widget.stock?.shelfLife.toString() ?? '');
    _purchaseDate = widget.stock?.purchaseDate ?? DateTime.now();
    _selectedLocation = widget.stock?.location ?? widget.location;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    _unitController.dispose();
    _shelfLifeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _purchaseDate) {
      setState(() {
        _purchaseDate = picked;
      });
    }
  }

  void _submit() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入食材名称')),
      );
      return;
    }

    if (_shelfLifeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入保质期天数')),
      );
      return;
    }

    final stock = model.FridgeStock(
      id: widget.stock?.id ?? 0,
      name: _nameController.text,
      accountId: widget.stock?.accountId ?? 0,
      count: int.tryParse(_countController.text),
      unit: _unitController.text,
      purchaseDate: _purchaseDate,
      shelfLife: int.parse(_shelfLifeController.text),
      location: _selectedLocation,
    );

    if (widget.stock == null) {
      widget.onAdd(stock);
    } else {
      widget.onUpdate(stock);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        height: 450,
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            // 按钮行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.stock != null) ...[
                  TextButton(
                    onPressed: () {
                      widget.onDelete(widget.stock!.id);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '删除',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ] else ...[
                  const SizedBox(width: 60),
                ],
                Text(
                  widget.location == 'refrigerated' ? '冷藏食材' : '冷冻食材',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _submit,
                  child: const Text('确认'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 名称
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: '食材名称',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // 数量和单位
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _countController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '数量',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _unitController,
                            decoration: const InputDecoration(
                              labelText: '单位',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // 购入日期
                    InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '购入日期',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          '${_purchaseDate.year}-${_purchaseDate.month.toString().padLeft(2, '0')}-${_purchaseDate.day.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // 保质期
                    TextField(
                      controller: _shelfLifeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '保质期（天）',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // 存放区域
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '存放区域',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('冷藏'),
                              value: 'refrigerated',
                              groupValue: _selectedLocation,
                              visualDensity: VisualDensity.compact,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocation = value!;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('冷冻'),
                              value: 'frozen',
                              groupValue: _selectedLocation,
                              visualDensity: VisualDensity.compact,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocation = value!;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
