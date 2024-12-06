// 版本信息
import 'package:json_annotation/json_annotation.dart';

part 'version.g.dart';

@JsonSerializable()
class Version {
  int id;
  String version; // 版本
  String updateLog; // 更新内容
  String downloadAndroid; // 更新内容
  String downloadIos; // 更新内容

  Version({
    required this.id,
    required this.version,
    required this.updateLog,
    required this.downloadAndroid,
    required this.downloadIos,
  });

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(this);

  @override
  String toString() {
    return 'Version{id: $id, version: $version, updateLog: $updateLog}';
  }
}
