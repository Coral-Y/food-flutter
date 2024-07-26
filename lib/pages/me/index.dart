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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Iconify(
                  Cil.arrow_left,
                  size: 20,
                ),
                Iconify(
                  Cil.settings,
                  size: 20,
                )
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
              height: 10,
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
                  // 点击事件
                  print('Tapped on John Doe');
                },
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            // 功能区
            Expanded(
                child: GridView.count(
              crossAxisCount: 4,
              children: const [
                Feature(
                  name: '分类管理',
                  icon: Twemoji.card_file_box,
                ),
                Feature(
                  name: '联系我们',
                  icon: Twemoji.open_mailbox_with_raised_flag,
                )
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

  const Feature({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Iconify(icon), Text(name)],
    );
  }
}
