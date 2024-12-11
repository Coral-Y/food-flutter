import 'package:food/api/base.dart';
import 'package:food/model/common.dart';
import 'package:food/model/message.dart';

class MessageApi {
  MessageApi._();
  static final MessageApi _instance = MessageApi._();
  factory MessageApi() => _instance;

  // 获取留言列表
  Future<Pager<Message>> list({int? current, int? pageSize}) async {
    try {
      var response = await BaseApi.request
          .get("/messages", params: {'current': current ?? 1, 'pageSize': 10});
      print(Pager<Message>.fromJson(
        response,
        (json) => Message.fromJson(json as Map<String, dynamic>),
      ));
      return Pager<Message>.fromJson(
        response,
        (json) => Message.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      print("获取留言信息: $e");
      rethrow;
    }
  }

  // 新增留言
  Future<void> create({
    required String title,
    required String type,
    required String content,
  }) async {
    await BaseApi.request.post("/messages", data: {
      'title': title,
      'type': type,
      'content': content,
    });
  }
}
