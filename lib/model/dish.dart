// 每一顿的菜品，可能从自制食谱中选择，也可以自定义
class Dish {
  String title; // 标题
  String icon; // 图标
  bool isRecipe; // 是否是食谱
  String? recipeId; // 食谱Id
  int type; // 类型 1-早餐 2-中餐 3-晚餐
  DateTime date; // 日期

  Dish(
      {required this.title,
      required this.icon,
      required this.type,
      required this.date,
      this.isRecipe = false});
}
