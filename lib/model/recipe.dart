// 自制食谱
import 'package:food/model/kind.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:food/config.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  int id;
  String name; // 名称
  String image; // 图片
  @JsonKey(toJson: kindToJson, fromJson: kindFromJson)
  Kind? kind; // 分类
  String? kindIcon; //菜谱图标
  List<String> ingredients; // 食材
  List<String>? seasonings; // 调味品
  List<String>? instructions; // 步骤

  static Map<String, dynamic>? kindToJson(Kind? value) => value?.toJson();

  static Kind? kindFromJson(Map<String, dynamic>? json) {
    // 确保 null 安全
    return json == null ? null : Kind.fromJson(json);
  }

  Recipe(
      {required this.id,
      required this.name,
      required this.image,
      List<String>? ingredients,
      this.seasonings,
      this.kind,
      this.kindIcon,
      this.instructions})
      : ingredients = ingredients ?? [];

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      ingredients: _parseStringOrList(json['ingredients']),
      seasonings: _parseStringOrList(json['seasonings']),
      instructions: _parseStringOrList(json['instructions']),
      kind: kindFromJson(json['kind'] as Map<String, dynamic>?),
      kindIcon: json['kindIcon'] as String?,
    );
  }

// 添加一个静态方法来处理字符串或列表的解析
  static List<String> _parseStringOrList(dynamic value) {
    if (value == null) {
      return [];
    }
    if (value is String) {
      return value.isEmpty ? [] : value.split('^');
    }
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'ingredients': ingredients,
      'seasonings': seasonings,
      'instructions': instructions,
      'kind': kindToJson(kind),
      'kindIcon': kindIcon,
    };
  }

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, image: $image, ingredients: $ingredients, seasonings: $seasonings, kind: $kind, instructions: $instructions,kindIcon: $kindIcon}';
  }
}
