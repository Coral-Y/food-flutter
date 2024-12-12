// 每一顿的菜品，可能从自制食谱中选择，也可以自定义
class Dish {
  int id;
  String title; // 标题
  String? icon;
  String type; //类型 breakfast：早餐 lunch：中餐 dinner：晚餐
  int? recipeId; // 食谱id
  int? sort; // 排序
  DateTime date; // 日期

  Dish({
    required this.id,
    required this.title,
    this.icon,
    required this.type,
    required this.date,
    this.recipeId,
    this.sort,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as int,
      title: json['title'] as String,
      icon: json['icon']  ?? '',
      type: json['type'] as String,
      sort: json['sort'] as int? ?? 0,
      date: DateTime.parse(json['date'] as String),
      recipeId: json['recipeId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'type': type,
      'sort': sort,
      'date':
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      if (recipeId != null) 'recipeId': recipeId,
    };
  }
}
