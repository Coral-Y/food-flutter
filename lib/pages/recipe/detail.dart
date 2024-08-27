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
            
            Row(
              children: [
                Container(
                  width: 180,
                  color: const Color(0xFFFFFFFE),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(4),
                    padding: const EdgeInsets.fromLTRB(35,20,0,20),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            '食材',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('生菜'),
                        Text('黑椒猪肉肠'),
                        Text('鸡蛋'),
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
