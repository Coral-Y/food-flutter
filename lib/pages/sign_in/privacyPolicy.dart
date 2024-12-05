import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
            Header(title: '隐私协议'),
            SizedBox(
              height: 10,
            ),
            Text('我们非常重视您的隐私。本隐私协议旨在帮助您了解我们如何收集、使用、存储和保护您的个人信息。'),
            SizedBox(
              height: 10,
            ),
            Text(
              '1. 收集的信息',
              style: TextStyle(fontSize: 16),
            ),
            Text('• 个人信息：例如用户名、手机号等，用于注册和登录。'),
            Text('• 使用数据：例如访问时间、操作行为等，以优化用户体验'),
            SizedBox(
              height: 10,
            ),
            Text(
              '2. 信息的使用',
              style: TextStyle(fontSize: 16),
            ),
            Text('我们仅在以下情况下使用您的信息：'),
            Text('• 提供、维护和改进我们的服务。'),
            Text('• 进行数据分析以优化产品体验'),
            Text('• 符合法律法规的要求或协助执法机关的合法调查'),
            SizedBox(
              height: 10,
            ),
            Text(
              '3. 信息的存储与保护',
              style: TextStyle(fontSize: 16),
            ),
            Text('• 您的信息将安全存储在我们服务器所在的国家。'),
            Text('• 我们采取技术手段保护您的信息安全，但无法保证其免受一切外部攻击。'),
            SizedBox(
              height: 10,
            ),
            Text(
              '4. 信息的共享与披露',
              style: TextStyle(fontSize: 16),
            ),
            Text('除以下情况外，我们不会与第三方共享您的个人信息：'),
            Text('• 获得您的明确同意。'),
            Text('• 法律法规要求。'),
            SizedBox(
              height: 10,
            ),
            Text(
              '5. 用户权利',
              style: TextStyle(fontSize: 16),
            ),
            Text('• 您可以随时查阅、更正或删除您的个人信息。'),
            Text('• 您有权撤销同意，但可能会影响某些功能的正常使用。'),
            SizedBox(
              height: 10,
            ),
            Text(
              '6. 未成年人隐私保护',
              style: TextStyle(fontSize: 16),
            ),
            Text('若您是未成年人，请在监护人的指导下使用本应用，并确保监护人已同意本协议。'),
            SizedBox(
              height: 10,
            ),
            Text('7. 协议修改'),
            Text('我们可能会不时更新本隐私协议，任何更新将在应用内通知用户并在更新后生效。'),
            SizedBox(
              height: 10,
            ),
            Text('8. 联系方式'),
            Text('若您对本协议有任何疑问或建议，请通过以下方式联系我们：'),
            Text('• 小红书：曲奇工作室')
          ],
        ),
      )),
    );
  }
}
