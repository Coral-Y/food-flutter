import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart';

@JsonSerializable()
class ModuleDescription {
  String? image;
  String? text;

  ModuleDescription({
    this.image,
    this.text,
  });

  factory ModuleDescription.fromJson(Map<String, dynamic> json) =>
      _$ModuleDescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleDescriptionToJson(this);
}

@JsonSerializable()
class Module {
  int id;
  String icon;
  String name;
  double price;

  @JsonKey(
      fromJson: Module._descriptionFromJson, toJson: Module._descriptionToJson)
  ModuleDescription? description;

  final String? endTime;

  Module({
    required this.id,
    required this.icon,
    required this.name,
    required this.price,
    this.description,
    this.endTime,
  });

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleToJson(this);

  /// 兼容 Map 或 String 的 description 字段
  static ModuleDescription? _descriptionFromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) {
      return ModuleDescription(text: json);
    } else if (json is Map<String, dynamic>) {
      return ModuleDescription.fromJson(json);
    }
    throw Exception("Invalid type for description");
  }

  static dynamic _descriptionToJson(ModuleDescription? desc) {
    return desc?.toJson();
  }
}
