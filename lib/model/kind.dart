import 'package:json_annotation/json_annotation.dart';

part 'kind.g.dart';

@JsonSerializable()
class Kind {
  int id;
  String name;
  String icon;

  Kind({required this.id, required this.name, required this.icon});

  factory Kind.fromJson(Map<String, dynamic> json) => _$KindFromJson(json);

  Map<String, dynamic> toJson() => _$KindToJson(this);

  @override
  String toString() {
    return 'Kind{id:$id, name: $name, icon: $icon}';
  }
}
