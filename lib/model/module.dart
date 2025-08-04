import 'dart:convert'; // 👈 添加这一行
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
    fromJson: Module._descriptionFromJson,
    toJson: Module._descriptionToJson,
  )
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

  static ModuleDescription? _descriptionFromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      try {
        final map = jsonDecode(json);
        if (map is Map<String, dynamic>) {
          return ModuleDescription.fromJson(map);
        } else {
          throw Exception("Parsed JSON is not a map");
        }
      } catch (e) {
        throw Exception("Invalid JSON string for description: $e");
      }
    }

    if (json is Map<String, dynamic>) {
      return ModuleDescription.fromJson(json);
    }

    throw Exception("Invalid type for description: ${json.runtimeType}");
  }

  static dynamic _descriptionToJson(ModuleDescription? desc) {
    return desc?.toJson();
  }
}
