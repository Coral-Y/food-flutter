import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart'; // ⚠️ 与文件名保持一致

@JsonSerializable()
class Module {
  int id;
  String icon;
  String name;
  int price;
  String description;
  final String? endTime; // ✅ 可空字段

  Module({
    required this.id,
    required this.icon,
    required this.name,
    required this.price,
    required this.description,
    this.endTime,
  });

  factory Module.fromJson(Map<String, dynamic> json) =>
      _$ModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleToJson(this);

  @override
  String toString() {
    return 'Module{id: $id, icon: $icon, name: $name, price: $price, description: $description, endTime: $endTime}';
  }
}
