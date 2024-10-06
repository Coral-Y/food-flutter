// 图标
import 'package:json_annotation/json_annotation.dart';

part 'icon.g.dart';

@JsonSerializable()
class FoodIcon {
  int id;
  String cnName; // 名称
  String enName; // 英文名
  String type; // 类型

  FoodIcon({
    required this.id,
    required this.cnName,
    required this.enName,
    required this.type,
  });

  factory FoodIcon.fromJson(Map<String, dynamic> json) =>
      _$FoodIconFromJson(json);

  Map<String, dynamic> toJson() => _$FoodIconToJson(this);

  @override
  String toString() {
    return 'FoodIcon{id: $id, cnName: $cnName, enName: $enName, url: $type}';
  }
}
