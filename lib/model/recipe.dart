// 自制食谱
import 'package:food/model/kind.dart';

class Recipe {
  String name; // 名称
  String image; // 图片
  Kind? kind; // 分类
  List<String> ingredients; // 食材
  List<String>? seasonings; // 调味品
  List<String>? instructions; // 步骤

  Recipe(
      {required this.name,
      required this.image,
      List<String>? ingredients,
      this.seasonings,
      this.instructions})
      : ingredients = ingredients ?? [];
}
