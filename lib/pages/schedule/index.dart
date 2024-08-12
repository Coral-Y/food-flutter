import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final List<String> week = <String>['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  final List<String> types = <String>['早餐', '中餐', '晚餐'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 头部背景及用户头像展示
          Stack(
            children: [
              Image.asset(
                'assets/images/food.png',
                width: double.infinity,
                height: 210,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 60,
                left: 30,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/me');
                    },
                    child: const CircleAvatar(
                        radius: 26, // 半径
                        backgroundImage:
                            AssetImage('assets/images/strawberry.png'))),
              )
            ],
          ),

          // 滚动日期选择
          Container(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            padding: const EdgeInsets.fromLTRB(5, 6, 5, 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: week
                        .map((item) => Container(
                              width: 30,
                              alignment: Alignment.center,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList()),
                const SizedBox(
                  height: 8,
                ),
                DatePicker(
                  start: DateTime.now(),
                )
              ],
            ),
          ),

          // 三餐展示
          Expanded(
              child: ListView.builder(
            itemCount: types.length,
            padding: const EdgeInsets.only(top: 15),
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

class DatePicker extends StatefulWidget {
  final DateTime start;
  const DatePicker({super.key, required this.start});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    List<String> list = List.generate(
        7,
        (index) =>
            DateFormat('dd').format(widget.start.add(Duration(days: index))));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list
          .map((item) => Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  item,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
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
