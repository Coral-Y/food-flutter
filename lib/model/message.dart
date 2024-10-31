class Message {
  int id;
  String title;
  String type;
  String content;
  String createdAt;
  Publisher publisher;

  Message({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.publisher,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    try {
      return Message(
        id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
        title: json['title']?.toString() ?? '', // 添加空值处理
        type: json['type']?.toString() ?? '', // 添加空值处理
        content: json['content']?.toString() ?? '',
        createdAt: json['createdAt']?.toString() ?? '',
        publisher:
            Publisher.fromJson(json['publisher'] as Map<String, dynamic>),
      );
    } catch (e) {
      print('Error parsing Message: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'content': content,
        'publisher': publisher.toJson(),
      };

  @override
  String toString() {
    return 'Message{id: $id, title: $title, type: $type, content: $content,createdAt: $createdAt, publisher: $publisher}';
  }
}

class Publisher {
  int id;
  String name;
  String phone;
  String type;
  String avatar;

  Publisher({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    required this.avatar,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      type: json['type'] as String,
      avatar: json['avatar'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'type': type,
        'avatar': avatar,
      };
}
