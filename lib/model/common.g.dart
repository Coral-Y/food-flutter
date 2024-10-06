// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pager<T> _$PagerFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Pager<T>(
      current: (json['current'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPage: (json['totalPage'] as num?)?.toInt() ?? 1,
      list:
          (json['list'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
    );

Map<String, dynamic> _$PagerToJson<T>(
  Pager<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'current': instance.current,
      'pageSize': instance.pageSize,
      'total': instance.total,
      'totalPage': instance.totalPage,
      'list': instance.list.map(toJsonT).toList(),
    };
