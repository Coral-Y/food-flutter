import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String? type;
  final String? size;

  const CButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.type = 'primary',
      this.size = 'middle'});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              Color(type == 'primary' ? 0xff232946 : 0xffd4939d)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 5, vertical: 3), // 设置内边距
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular( size == 'small' ? 4 : 6), // 设置圆角
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: size == 'small' ? 12 : 14),
        ));
  }
}
