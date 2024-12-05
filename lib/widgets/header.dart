import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food/config.dart';

class Header extends StatelessWidget {
  final String title;
  final String? icon;
  final bool showIcon;

  const Header(
      {super.key, required this.title, this.icon, this.showIcon = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: showIcon,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Iconify(
                Cil.arrow_left,
                size: 20,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                SvgPicture.network(
                  '$ICON_SERVER_URI$icon.svg',
                  placeholderBuilder: (BuildContext context) =>
                      const CircularProgressIndicator(),
                ),
                const SizedBox(width: 2),
              ],
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
