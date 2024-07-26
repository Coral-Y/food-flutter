import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food/pages/recipe/index.dart';
import 'package:food/pages/schedule/index.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        // 导航切换
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: const Color(0xFFF5F5F5),
        currentIndex: currentPageIndex,
        showUnselectedLabels: true,
        selectedItemColor: const Color(0xFF333333),
        unselectedItemColor: const Color(0xFF333333),
        items: [
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/schedule.svg',
              width: 20,
              height: 20,
            ),
            icon: SvgPicture.asset(
              'assets/icons/schedule.svg',
              width: 20,
              height: 20,
            ),
            label: '规划',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/recipe.svg',
              width: 20,
              height: 20,
            ),
            icon: SvgPicture.asset(
              'assets/icons/recipe.svg',
              width: 20,
              height: 20,
            ),
            label: '食谱',
          ),
        ],
      ),
      body: <Widget>[
        /// 一周食谱
        const Schedule(),

        /// 食谱管理
        const RecipeList(),
      ][currentPageIndex],
    );
  }
}
