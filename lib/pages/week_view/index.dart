import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food/api/schedules.dart';
import 'package:food/widgets/header.dart';
import 'package:food/model/dish.dart';
import 'package:intl/intl.dart';

class WeekView extends StatefulWidget {
  const WeekView({super.key});

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  final List<String> week = <String>['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  DateTime current = DateTime.now();
  DateTime get start {
    return current.subtract(Duration(days: current.weekday - 1));
  }

  DateTime get end {
    return start.add(const Duration(days: 7));
  }

  List<DateTime> get dateList {
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  Map<String, List<Dish>> schedules = {};

  @override
  void initState() {
    super.initState();
    getScheduleData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // 获取周规划列表
  Future<void> getScheduleData() async {
    try {
      var data = await SchedulesApi().getRangeSchedules(start, end);
      setState(() {
        schedules = data;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Column(
          children: [
            // 头部标题
            const Header(
              title: '周视图',
              paddingBottom: 5,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: week
                    .map((item) => Expanded(
                          child: Text(
                            item,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList()),
            const SizedBox(
              height: 5,
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: dateList
                    .map((item) => Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Column(
                            children: [
                              Text('${item.day}'),
                              ...(schedules[DateFormat('yyyy-MM-dd')
                                          .format(item)] ??
                                      [])
                                  .map((dish) => DishItem(dish: dish))
                            ],
                          ),
                        )))
                    .toList(),
              ),
            ))
          ],
        ),
      )),
    );
  }
}

class DishItem extends StatefulWidget {
  final Dish dish;
  const DishItem({super.key, required this.dish});

  @override
  State<DishItem> createState() => _DishItemState();
}

class _DishItemState extends State<DishItem> {
  var config = {
    'breakfast': {
      'name': '早餐',
      'color': const Color(0xFF4CAF50),
      'bgColor': const Color(0xFFE8F5E9)
    },
    'lunch': {
      'name': '中餐',
      'color': const Color(0xFFFF9800),
      'bgColor': const Color(0xFFFFF3E0)
    },
    'dinner': {
      'name': '晚餐',
      'color': const Color(0xFF2783de),
      'bgColor': const Color(0x340076d9)
    }
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                spreadRadius: -2,
                blurRadius: 12,
                color: Color(0x14ffffff),
                offset: Offset(0, 4)),
            BoxShadow(spreadRadius: 1, color: Color(0x14544831))
          ],
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      margin: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.dish.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Container(
            decoration: BoxDecoration(
                color: config[widget.dish.type]!['bgColor'] as Color,
                borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              config[widget.dish.type]!['name']! as String,
              style: TextStyle(
                color: config[widget.dish.type]!['color'] as Color,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}
