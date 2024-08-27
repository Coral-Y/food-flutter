import 'package:flutter/material.dart';

class CListTile extends StatelessWidget {
  final String title;
  final double? padding;
  final Widget? leading;
  final VoidCallback? onTap;

  const CListTile({
    super.key,
    required this.title,
    this.leading,
    this.padding = 4,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding!),
        child: Row(
          children: [
            if (leading != null) // 如果 text 存在，显示 Text
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: leading,
              ),
            Text(title)
          ],
        ),
      ),
    );
  }
}
