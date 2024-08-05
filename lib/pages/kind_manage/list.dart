import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';

class KindManage extends StatefulWidget {
  const KindManage({super.key});

  @override
  State<KindManage> createState() => _KindManageState();
}

class _KindManageState extends State<KindManage> {
  final List<Kind> kinds = [
    Kind(name: '荤菜', icon: Twemoji.shallow_pan_of_food),
    Kind(name: '素菜', icon: Twemoji.green_salad),
    Kind(name: '主食', icon: Twemoji.cooked_rice),
    Kind(name: '汤羹', icon: Twemoji.pot_of_food),
  ];
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
            const SizedBox(
              height: 10,
            ),
            FilledButton.icon(
              onPressed: () {},
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
                child: ListView.separated(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: kinds.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          color: Color(0xFF999999),
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Iconify(
                                kinds[index].icon,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                kinds[index].name,
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Iconify(
                                Cil.color_border,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Iconify(
                                Cil.trash,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            ],
                          )
                        ],
                      );
                    }))
          ],
        ),
      )),
    );
  }
}

class Kind {
  String name;
  String icon;

  Kind({required this.name, required this.icon});
}
