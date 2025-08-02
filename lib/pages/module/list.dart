import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food/api/modules.dart';
import 'package:food/config.dart';
import 'package:food/model/module.dart';
import 'package:food/widgets/header.dart';

class ModuleList extends StatefulWidget {
  const ModuleList({super.key});

  @override
  State<ModuleList> createState() => _ModuleListState();
}

class _ModuleListState extends State<ModuleList> {
  List<Module> modules = [];

  Future<void> getModulesList() async {
    try {
      var res = await ModulesApi().list();
      setState(() {
        modules = res.list;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getModulesList();
  }

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
                  id: modules[index].id,
                  icon: modules[index].icon,
                  title: modules[index].name,
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
  final int id;
  final String icon;
  final String title;
  final String? endTime;

  const ModuleCard(
      {super.key,
      required this.id,
      required this.icon,
      required this.title,
      this.endTime});

  @override
  Widget build(BuildContext context) {
    final isExpired = endTime == null;

    return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/moduleDetail',
            arguments: {
              'moduleId': id,
              'moduleName': title,
            },
          );
        },
        child: Card(
          elevation: 0,
          color: isExpired
              ? const Color.fromARGB(10, 158, 157, 157)
              : Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color(0xFF333333),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            height: 150, // 可根据实际卡片高度调整
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    '$IMG_SERVER_URI$icon',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 5),
                  Text(title),
                  if (!isExpired)
                    Text(
                      '$endTime 到期',
                      style: const TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}
