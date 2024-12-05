import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';

class UserAgreement extends StatelessWidget {
  const UserAgreement({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Header(title: '用户协议'),
            SizedBox(
              height: 10,
            ),
            Text(
                '感谢您选择使用我们的应用程序“食”（以下简称“本应用”）。在使用本应用前，请您仔细阅读以下用户协议条款。您的使用行为即表示您已同意遵循以下条款'),
            SizedBox(
              height: 10,
            ),
            Text(
              '1. 服务内容',
              style: TextStyle(fontSize: 16),
            ),
            Text('本应用为用户提供饮食规划、食谱管理等功能。具体功能会根据实际运营需要进行调整。'),
            SizedBox(
              height: 10,
            ),
            Text(
              '2. 用户权力与义务',
              style: TextStyle(fontSize: 16),
            ),
            Text('• 您承诺提供的所有注册信息均真实、准确、完整。'),
            Text('• 您在使用本应用的过程中不得发布违法、违规或侵犯他人权利的内容。'),
            SizedBox(
              height: 10,
            ),
            Text(
              '3. 知识产权',
              style: TextStyle(fontSize: 16),
            ),
            Text(
                '本应用及相关服务中的所有内容（包括但不限于代码、图片、文字）均受知识产权保护。未经许可，用户不可复制、修改、传播相关内容'),
                SizedBox(
              height: 10,
            ),
            Text(
              '4. 服务变更与终止',
              style: TextStyle(fontSize: 16),
            ),
            Text('我们保留随时修改、暂停或终止部分或全部服务的权利，并提前通知用户'),
            SizedBox(
              height: 10,
            ),
            Text(
              '5. 免责声明',
              style: TextStyle(fontSize: 16),
            ),
            Text('我们将尽力确保本应用服务的稳定性和安全性，但不对因不可抗力或第三方因素导致的损失承担责任'),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }
}
