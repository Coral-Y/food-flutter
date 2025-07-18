// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      image: json['image'] as String,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      seasonings: (json['seasonings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      kind: Recipe.kindFromJson(json['kind'] as Map<String, dynamic>?),
      kindIcon: json['kindIcon'] as String?,
      instructions: (json['instructions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'kind': Recipe.kindToJson(instance.kind),
      'kindIcon': instance.kindIcon,
      'ingredients': instance.ingredients,
      'seasonings': instance.seasonings,
      'instructions': instance.instructions,
    };
