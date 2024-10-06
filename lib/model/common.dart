import 'package:json_annotation/json_annotation.dart';

part 'common.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Pager<T> {
  @JsonKey(name: 'current')
  final int current;

  @JsonKey(name: 'pageSize')
  final int pageSize;

  @JsonKey(name: 'total')
  final int total;

  @JsonKey(name: 'totalPage')
  final int totalPage;

  @JsonKey(name: 'list')
  final List<T> list;

  Pager({
    this.current = 1,
    this.pageSize = 10,
    this.total = 0,
    this.totalPage = 1,
    this.list = const [],
  });

  factory Pager.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PagerFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(T Function(T value) toJsonT) =>
      _$PagerToJson(this, toJsonT);

  @override
  String toString() {
    return 'Pager{current: $current, pageSize: $pageSize, total: $total, totalPage: $totalPage, list: $list}';
  }
}
