import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final List<String> types = <String>['早餐', '中餐', '晚餐'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 头部背景及用户头像展示
          Image.asset(
            'assets/images/food.png',
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),

          // 滚动日期选择
          Container(
            height: 100,
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),

          // 三餐展示
          Expanded(
              child: ListView.builder(
            itemCount: types.length,
            itemBuilder: (context, index) {
              return FoodCard(
                title: types[index],
              );
            },
          ))
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String title;

  const FoodCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Container(
                height: 100,
              )
            ],
          ),
        ));
  }
}
