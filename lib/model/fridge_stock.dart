// 冰箱库存
class FridgeStock {
  int id;
  String name; // 名称
  int accountId; // 创建人id
  int? count; // 数量
  String unit; // 单位
  DateTime purchaseDate; // 购入时间
  int shelfLife; // 可保存天数
  String location; // 类型：refrigerated(冷藏) 或 frozen(冷冻)

  FridgeStock({
    required this.id,
    required this.name,
    required this.accountId,
    this.count,
    required this.unit,
    required this.purchaseDate,
    required this.shelfLife,
    required this.location,
  });

  factory FridgeStock.fromJson(Map<String, dynamic> json) {
    return FridgeStock(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'] as String,
      accountId: json['accountId'] is String
          ? int.parse(json['accountId'])
          : json['accountId'] as int,
      count: json['count'] as int?,
      unit: json['unit'] as String? ?? '个',
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      shelfLife: json['shelfLife'] is String
          ? int.parse(json['shelfLife'])
          : json['shelfLife'] as int,
      location: json['location'] as String? ?? 'refrigerated',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountId': accountId,
      'count': count,
      'unit': unit,
      'purchaseDate':
          "${purchaseDate.year}-${purchaseDate.month.toString().padLeft(2, '0')}-${purchaseDate.day.toString().padLeft(2, '0')}",
      'shelfLife': shelfLife,
      'location': location,
    };
  }

  @override
  String toString() {
    return 'FridgeStock{id: $id, name: $name, accountId: $accountId, count: $count, unit: $unit, purchaseDate: $purchaseDate, shelfLife: $shelfLife, location: $location}';
  }
}

