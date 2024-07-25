import 'package:flutter/material.dart';

/// 使用阿里图标库内图标
/// 新增图标步骤：
/// 1. 将图标的svg文件上传至阿里图标库
/// 2. 将图标下载至本地，使用压缩包内的 .ttf 文件替换项目下 assets/fonts/iconfont.ttf文件
/// 3. 在本文件中按格式新增一个IconData后，就可以使用了
class CustomIcon {
  // 食谱
  static const IconData recipe = IconData(
    0xf0cf,
    fontFamily: "CustomIcon",
  );
  // 规划
  static const IconData schedule = IconData(
    0xf0c0,
    fontFamily: "CustomIcon",
  );
}
