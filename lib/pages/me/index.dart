import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
        child: Column(
          children: [
            // 操作区
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Iconify(
                    Cil.arrow_left,
                    size: 20,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // TODO:跳转到设置页
                  },
                  child: const Iconify(
                    Cil.settings,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            // 用户卡片
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              height: 150,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: 25, // 半径
                        backgroundImage:
                            AssetImage('assets/images/strawberry.png')),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '曲奇',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
            ),

            const SizedBox(
              height: 15,
            ),

            // 模块
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: ListTile(
                leading: const Iconify(Twemoji.package),
                title: const Text('装备'),
                subtitle: Text('2/4'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // TODO:跳转到装备列表
                  Navigator.of(context).pushNamed('/moduleList');
                },
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // 功能区
            Expanded(
                child: GridView.count(
              crossAxisCount: 4,
              children: const [
                Feature(name: '分类管理', icon: Twemoji.card_file_box, route: ''),
                Feature(
                    name: '联系我们',
                    icon: Twemoji.open_mailbox_with_raised_flag,
                    route: '/contactUs')
              ],
            ))
          ],
        ),
      )),
    );
  }
}

class Feature extends StatelessWidget {
  final String name;
  final String icon;
  final String route;

  const Feature(
      {super.key, required this.name, required this.icon, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Column(
        children: [Iconify(icon), Text(name)],
      ),
    );
  }
}
