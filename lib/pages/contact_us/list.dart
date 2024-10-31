import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:food/model/message.dart';
import 'package:food/model/common.dart';
import 'package:food/api/message.dart';
import 'package:food/widgets/c_snackbar.dart';

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
                        Header(title: '联系我们'),
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
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    title: messages[index].title,
                                    senderName: messages[index].publisher.name,
                                    avatar: messages[index].publisher.avatar,
                                    content: messages[index].content,
                                    time: messages[index].createdAt,
                                  );
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
                          onPressed: () {
                            Navigator.of(context).pushNamed('/leaveMessage');
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/strawberry.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(
                  senderName,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content),
              const SizedBox(
                height: 2,
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
