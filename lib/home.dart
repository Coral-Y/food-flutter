import 'package:flutter/material.dart';
import 'package:food/me/index.dart';
import 'package:food/recipe/index.dart';
import 'package:food/schedule/index.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        // 导航切换
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        height: 60,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Iconify(Cil.calendar) ,
            icon: Iconify(Cil.calendar),
            label: 'Schedule',
          ),
          NavigationDestination(
            selectedIcon: Iconify(Cil.fastfood),
            icon: Iconify(Cil.fastfood),
            label: 'Recipe',
          ),
          NavigationDestination(
            selectedIcon: Iconify(Cil.happy),
            icon: Iconify(Cil.happy),
            label: 'Me',
          ),
        ],
      ),
      body: <Widget>[
        /// 一周食谱
        const Schedule(),

        /// 食谱管理
        const Recipe(),

        /// 个人中心
        const Me(),
      ][currentPageIndex],
    );
  }
}