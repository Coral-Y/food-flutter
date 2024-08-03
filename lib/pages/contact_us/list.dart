import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Stack(
                  children: [
                    const Column(
                      children: [
                        Header(title: '联系我们'),
                        SizedBox(
                          height: 10,
                        ),
                        MessageCard(
                          title: '我是标题',
                          time: '2024-7-24 9:37',
                          content:
                              '我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容',
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
  final String title;
  final String content;
  final String time;

  const MessageCard(
      {super.key,
      required this.title,
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
            Text(title),
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
