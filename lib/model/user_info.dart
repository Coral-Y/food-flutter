class UserInfo {
  int id;
  String name; // 用户名
  String avatar; // 头像
  String phone; // 手机号
  String type; // 类型

  UserInfo({
    required this.id,
    required this.name,
    required this.avatar,
    required this.phone,
    required this.type,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    print(json['id']);
    return UserInfo(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar']?.toString() ?? "",
      phone: json['phone'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'phone': phone,
        'type': type,
      };

  @override
  String toString() {
    return 'UserInfo{id: $id, name: $name, avatar: $avatar, phone: $phone, type: $type}';
  }
}
