import 'package:flutter/material.dart';

class ClosableDialog extends StatelessWidget {
  final String title;
  final Widget child; // 自定义内容
  final VoidCallback? onClose;

  const ClosableDialog({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 自定义内容
                child,
              ],
            ),
          ),
          // X 关闭按钮
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
                onClose?.call();
              },
            ),
          ),
        ],
      ),
    );
  }
}
