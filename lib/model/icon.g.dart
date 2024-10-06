// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodIcon _$FoodIconFromJson(Map<String, dynamic> json) => FoodIcon(
      id: (json['id'] as num).toInt(),
      cnName: json['cnName'] as String,
      enName: json['enName'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$FoodIconToJson(FoodIcon instance) => <String, dynamic>{
      'id': instance.id,
      'cnName': instance.cnName,
      'enName': instance.enName,
      'type': instance.type,
    };
