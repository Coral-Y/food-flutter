// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleDescription _$ModuleDescriptionFromJson(Map<String, dynamic> json) =>
    ModuleDescription(
      image: json['image'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$ModuleDescriptionToJson(ModuleDescription instance) =>
    <String, dynamic>{
      'image': instance.image,
      'text': instance.text,
    };

Module _$ModuleFromJson(Map<String, dynamic> json) => Module(
      id: (json['id'] as num).toInt(),
      icon: json['icon'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: Module._descriptionFromJson(json['description']),
      endTime: json['endTime'] as String?,
    );

Map<String, dynamic> _$ModuleToJson(Module instance) => <String, dynamic>{
      'id': instance.id,
      'icon': instance.icon,
      'name': instance.name,
      'price': instance.price,
      'description': Module._descriptionToJson(instance.description),
      'endTime': instance.endTime,
    };
