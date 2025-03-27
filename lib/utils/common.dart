import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

String arrayToString(List<String>? array) =>
    (array == null || array.isEmpty) ? '' : array.join('^');

List<String> stringToArray(String? str) =>
    (str == null || str.isEmpty) ? [] : str.split('^');

// 获取文件大小
String getFileSize(int length) {
  if (length < 1024) {
    return '$length B'; // 小于 1 KB 的用字节表示
  } else if (length < 1024 * 1024) {
    double sizeInKB = length / 1024;
    return '${sizeInKB.toStringAsFixed(2)} KB'; // 小于 1 MB 的用 KB 表示
  } else if (length < 1024 * 1024 * 1024) {
    double sizeInMB = length / (1024 * 1024);
    return '${sizeInMB.toStringAsFixed(2)} MB'; // 小于 1 GB 的用 MB 表示
  } else {
    double sizeInGB = length / (1024 * 1024 * 1024);
    return '${sizeInGB.toStringAsFixed(2)} GB'; // 大于或等于 1 GB 的用 GB 表示
  }
}

// 压缩图片
Future<String?> compressImage(XFile file) async {
  try {
    String path = file.path;
    int quality = 90;
    List<String> res = path.split('.');
    res.removeLast();
    String url = res.join('.');
    int length = await file.length();
    String targetPath = '${url}_compressed.jpg';

    // 大于100KB
    while (length > 100 * 1024 || quality <= 10) {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        path, // 原文件路径
        targetPath, // 压缩后保存的目标路径
        quality: quality, // 压缩质量
      );

      // 检查是否成功压缩
      if (compressedFile == null) {
        return null;
      }
      length = await compressedFile.length();
      quality -= 10;
    }

    // 删除原文件（如果需要）
    File originFile = File(path);
    await originFile.delete();
    return targetPath;
  } catch (e) {
    print("压缩失败: $e");
    return null;
  }
}
