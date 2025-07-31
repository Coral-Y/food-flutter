import 'package:flutter/material.dart';

class CSnackBar {
  final String message;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _controller;

  CSnackBar({required this.message});

  SnackBar buildSnackBar() {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 2), // 2秒
      behavior: SnackBarBehavior.floating, // 悬浮
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10), // 设置边距
    );
  }

  void show(BuildContext context) {
    _controller = ScaffoldMessenger.of(context).showSnackBar(buildSnackBar());
  }

  void dispose() {
    try {
      _controller?.close();
    } catch (e) {
      debugPrint('CSnackBar关闭: $e');
    }
    _controller = null;
  }
}
