import 'package:food/api/base.dart';
import 'package:food/model/dish.dart';

class SchedulesApi {
  SchedulesApi._();
  static final SchedulesApi _instance = SchedulesApi._();
  factory SchedulesApi() => _instance;

  // 获取指定日期的规划
  Future<Map<String, List<Dish>>> getSchedules(DateTime date) async {
    try {
      var response = await BaseApi.request.get(
        "/schedules",
        params: {
          "date":
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
        },
      );

      Map<String, List<Dish>> result = {
        'breakfast': [],
        'lunch': [],
        'dinner': [],
      };

      if (response != null && response is Map) {
        // 处理早餐数据
        if (response['breakfast'] != null) {
          result['breakfast'] = (response['breakfast'] as List)
              .map((item) => Dish.fromJson(item))
              .toList();
        }

        // 处理午餐数据
        if (response['lunch'] != null) {
          result['lunch'] = (response['lunch'] as List)
              .map((item) => Dish.fromJson(item))
              .toList();
        }

        // 处理晚餐数据
        if (response['dinner'] != null) {
          result['dinner'] = (response['dinner'] as List)
              .map((item) => Dish.fromJson(item))
              .toList();
        }
      }

      return result;
    } catch (e) {
      print("Error getting schedules: $e");
      rethrow;
    }
  }

  // 更新规划排序
  Future<bool> updateSchedules(List<int> dishIds) async {
    try {
      if (dishIds.length < 2) {
        throw Exception('排序的菜品数量必须大于等于2');
      }

      await BaseApi.request.patch(
        "/schedules/batch",
        data: {
          "dishIds": dishIds,
        },
      );

      return true;
    } catch (e) {
      print("Error updating schedules: $e");
      return false;
    }
  }

  // 添加规划
  Future<bool> addSchedule(Dish dish) async {
    print(dish.toJson());
    try {
      Map<String, dynamic> data = {
        "title": dish.title,
        "type": dish.type,
        "icon": dish.icon,
        "date":
            "${dish.date.year}-${dish.date.month.toString().padLeft(2, '0')}-${dish.date.day.toString().padLeft(2, '0')}",
        "recipeId": dish.recipeId
      };

      await BaseApi.request.post(
        "/dishes",
        data: data,
      );
      return true;
    } catch (e) {
      print("Error adding schedule: $e");
      return false;
    }
  }

  // 修改规划
  Future<bool> updateSchedule(Dish dish) async {
    print(dish.toJson());
    try {
      Map<String, dynamic> data = {
        "title": dish.title,
        "type": dish.type,
        "icon": dish.icon,
        "date":
            "${dish.date.year}-${dish.date.month.toString().padLeft(2, '0')}-${dish.date.day.toString().padLeft(2, '0')}",
        "recipeId": dish.recipeId
      };

      await BaseApi.request.put(
        "/dishes/${dish.id}",
        data: data,
      );
      return true;
    } catch (e) {
      print("Error adding schedule: $e");
      return false;
    }
  }

  // 删除规划
  Future<bool> deletSchedule(int id) async {
    try {
      await BaseApi.request.delete("/dishes/${id}");
      return true;
    } catch (e) {
      print("Error adding schedule: $e");
      return false;
    }
  }
}
