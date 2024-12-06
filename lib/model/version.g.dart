// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) => Version(
      id: (json['id'] as num).toInt(),
      version: json['version'] as String,
      updateLog: json['updateLog'] as String,
      downloadAndroid: json['downloadAndroid'] as String,
      downloadIos: json['downloadIos'] as String,
    );

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'updateLog': instance.updateLog,
      'downloadAndroid': instance.downloadAndroid,
      'downloadIos': instance.downloadIos,
    };
