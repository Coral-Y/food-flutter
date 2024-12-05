import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:provider/provider.dart';
import 'package:food/providers/user_provider.dart';
import 'package:food/config.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  String imagePath = '';
  String nickname = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final userInfo = context.watch<UserProvider>().userInfo;
    if (userInfo != null) {
      setState(() {
        imagePath =
            userInfo.avatar.isNotEmpty ? IMG_SERVER_URI + userInfo.avatar : '';
        nickname = userInfo.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child:
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
                  // 设置页
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/settings');
                    },
                    child: const Iconify(
                      Cil.settings,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // 用户卡片
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                height: 150,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/editInfo',
                      arguments: {
                        'imagePath': imagePath, // 头像
                        'nickname': nickname, // 传入昵称
                      },
                    );
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent,
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
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          nickname,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ]),
                )),

            const SizedBox(
              height: 15,
            ),

            // 模块
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //     color: Colors.white,
            //   ),
            //   child: ListTile(
            //     leading: const Iconify(Twemoji.package),
            //     title: const Text('装备'),
            //     subtitle: Text('2/4'),
            //     trailing: const Icon(Icons.arrow_forward),
            //     onTap: () {
            //       Navigator.of(context).pushNamed('/moduleList');
            //     },
            //   ),
            // ),

            const SizedBox(
              height: 50,
            ),

            // 功能区
            Expanded(
                child: GridView.count(
              crossAxisCount: 4,
              children: const [
                // Feature(
                //     name: '分类管理',
                //     icon: Twemoji.card_index_dividers,
                //     route: '/kindManage'),
                Feature(
                    name: '联系我们',
                    icon: Twemoji.open_mailbox_with_raised_flag,
                    route: '/contactUs')
              ],
            )),
          ],
        ),
      ),
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
        children: [
          Iconify(icon),
          const SizedBox(
            height: 3,
          ),
          Text(name)
        ],
      ),
    );
  }
}
