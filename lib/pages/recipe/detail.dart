import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  @override
  Widget build(BuildContext context) {
    final String title = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(title: title),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  color: const Color(0xFFFFFFFE),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(4),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            '$title食材',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Text('生菜'),
                        const Text('黑椒猪肉肠'),
                        const Text('鸡蛋'),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('1. 把鱿鱼表面清洗干净'),
            const SizedBox(
              height: 20,
            ),
            const Text('2. 热油，放入蒜片和姜片'),
            const SizedBox(
              height: 20,
            ),
            const Text('3. 热油'),
            const SizedBox(
              height: 20,
            ),
            const Text('4. 搅拌均匀'),
          ],
        ),
      )),
    );
  }
}
