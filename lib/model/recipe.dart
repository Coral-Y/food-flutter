// 自制食谱
import 'package:food/model/kind.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  int id;
  String name; // 名称
  String image; // 图片
  @JsonKey(
    toJson: kindToJson,
  )
  Kind? kind; // 分类
  List<String> ingredients; // 食材
  List<String>? seasonings; // 调味品
  List<String>? instructions; // 步骤

  static Map<String, dynamic>? kindToJson(Kind? value) => value?.toJson();

  Recipe(
      {required this.id,
      required this.name,
      required this.image,
      List<String>? ingredients,
      this.seasonings,
      this.kind,
      this.instructions})
      : ingredients = ingredients ?? [];

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}
