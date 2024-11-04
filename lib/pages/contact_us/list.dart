import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:food/model/message.dart';
import 'package:food/model/common.dart';
import 'package:food/api/message.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:food/config.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  List<Message> messages = [];
  int current = 1;
  int totalPage = 1;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    getMessageList(1);
  }

  // 获取留言列表
  Future<void> getMessageList(int page) async {
    try {
      Pager<Message> res = await MessageApi().list(current: page);
      setState(() {
        current = res.current;
        totalPage = res.totalPage;
        if (page == 1) {
          messages = res.list;
        } else {
          messages.addAll(res.list);
        }
        hasMoreData = current < totalPage;
      });
    } catch (e) {
      print(e);
      CSnackBar(message: '获取留言列表失败').show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const Header(title: '联系我们'),
                        Expanded(
                          child: NotificationListener<ScrollEndNotification>(
                            onNotification:
                                (ScrollEndNotification scrollEndNotification) {
                              if (scrollEndNotification.metrics.pixels >=
                                  scrollEndNotification
                                      .metrics.maxScrollExtent) {
                                if (current < totalPage) {
                                  getMessageList(current + 1);
                                }
                              }
                              return true;
                            },
                            child: RefreshIndicator(
                              key: _refreshKey,
                              onRefresh: () => getMessageList(1), // 下拉刷新数据
                              child: ListView.builder(
                                itemCount: messages.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < messages.length) {
                                    // 显示消息卡片
                                    return MessageCard(
                                      title: messages[index].title,
                                      senderName:
                                          messages[index].publisher.name,
                                      avatar: IMG_SERVER_URI +
                                          messages[index].publisher.avatar,
                                      content: messages[index].content,
                                      time: messages[index].createdAt,
                                    );
                                  } else {
                                    // 显示“没有更多”提示
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(
                                        child: hasMoreData
                                            ? const CircularProgressIndicator() // 如果有更多数据，显示加载中指示器
                                            : const Text(
                                                '没有更多数据',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 60,
                      right: 0,
                      child: FilledButton(
                          onPressed: () async {
                            final result = await Navigator.of(context)
                                .pushNamed('/leaveMessage');
                            if (result == true) {
                              getMessageList(1); // 刷新数据
                            }
                          },
                          child: const Iconify(
                            Cil.pencil,
                            color: Colors.white,
                          )),
                    )
                  ],
                ))));
  }
}

class MessageCard extends StatelessWidget {
  final String avatar;
  final String title;
  final String senderName;
  final String content;
  final String time;

  const MessageCard(
      {super.key,
      required this.avatar,
      required this.title,
      required this.senderName,
      required this.content,
      required this.time});

  // 计算显示的时间字符串
  String getTimeDisplay(String time) {
    DateTime parsedTime = DateTime.parse(time); // 将 String 转换为 DateTime
    final now = DateTime.now();
    final difference = now.difference(parsedTime);

    if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays > 1) {
      return DateFormat('MM-dd HH:mm').format(parsedTime);
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像
              CircleAvatar(
                radius: 25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: avatar.isEmpty
                      ? Image.asset(
                          'assets/icons/cookie_color.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          avatar,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/avatar.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4.0),
                    if (title.isNotEmpty) // 如果有标题，显示标题
                      Text(
                        title,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    SizedBox(height: 8.0),
                    Text(
                      content,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      getTimeDisplay(time),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey[300]), // 分隔符
      ],
    );
  }
}
