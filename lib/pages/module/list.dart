import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food/widgets/header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';

class ModuleList extends StatefulWidget {
  const ModuleList({super.key});

  @override
  State<ModuleList> createState() => _ModuleListState();
}

class _ModuleListState extends State<ModuleList> {
  final List<Module> modules = [
    Module(
        icon: 'assets/icons/class.svg', title: '自定义分类', endTime: '2025-7-31'),
    Module(icon: 'assets/icons/recipe.svg', title: '菜谱数量上限')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
        child: Column(
          children: [
            // 头部标题
            const Header(title: '装备'),

            const SizedBox(
              height: 10,
            ),

            // 模块列表
            Expanded(
                child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.3,
                crossAxisCount: 2, // 每行两列
              ),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                return ModuleCard(
                  icon: modules[index].icon,
                  title: modules[index].title,
                  endTime: modules[index].endTime,
                );
              },
            ))
          ],
        ),
      )),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final String icon;
  final String title;
  final String? endTime;

  const ModuleCard(
      {super.key, required this.icon, required this.title, this.endTime});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // 去除阴影
      color: endTime != null ? Colors.white : const Color(0xFFF5F5F5),
      surfaceTintColor: Colors.white ,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xFF333333), // 边框颜色
          width: 1, // 边框宽度
        ),
        borderRadius: BorderRadius.circular(10), // 圆角半径
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          SvgPicture.asset(
            icon,
            width: 50,
            height: 50,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(title),
          endTime != null
              ? Text(
                  '$endTime到期',
                  style:
                      const TextStyle(color: Color(0xFF999999), fontSize: 12),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}

class Module {
  String icon;
  String title;
  String? endTime;

  Module({required this.icon, required this.title, this.endTime});
}
