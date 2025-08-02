import 'package:flutter/material.dart';
import 'package:food/api/modules.dart';
import 'package:food/config.dart';
import 'package:food/model/module.dart';
import 'package:food/widgets/c_button.dart';
import 'package:food/widgets/header.dart';

class ModuleDetail extends StatefulWidget {
  const ModuleDetail({super.key});

  @override
  State<ModuleDetail> createState() => _ModuleDetailState();
}

class _ModuleDetailState extends State<ModuleDetail> {
  late int moduleId;
  late String moduleName;
  Module? detail;
  bool loading = true;
  String? error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null || args['moduleId'] == null) {
      setState(() {
        error = '参数错误';
        loading = false;
      });
      return;
    }
    moduleId = args['moduleId'] is int
        ? args['moduleId']
        : int.tryParse(args['moduleId'].toString()) ?? 0;
    moduleName = args['moduleName'];
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      var res = await ModulesApi().detail(moduleId);
      print(res);
      setState(() {
        detail = res;
      });
    } catch (e) {
      setState(() {
        error = '加载失败';
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(title: moduleName),
                    loading
                        ? const Center(child: CircularProgressIndicator())
                        : error != null
                            ? Center(child: Text(error!))
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 70),
                                child: _buildCard(),
                              ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: 160,
              height: 54,
              child: CButton(
                text: "我要开通",
                onPressed: () async {
                  // 开通
                  showPaymentDialog(context, detail!.name!, detail!.price!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.black),
      ),
      color: Colors.white,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              alignment: Alignment.center,
              color: Colors.white,
              child: Image.network(
                '$IMG_SERVER_URI${detail?.icon}',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Text(
                  '图片加载失败',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
                children: [
                  Text(
                    detail!.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(detail!.description?.text ?? ''),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showPaymentDialog(BuildContext context, String name, double price) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        '结算',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('¥ $price',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            const Text(
              '注意事项：',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '1. 购买后，新增功能无需二次付费',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const Text(
              '2. 虚拟内容一经售出不予退换，请您确认购买',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const Text(
              '3. 仅支持微信支付',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('应付  ¥ $price',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFd4939d))),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 100,
                  child: CButton(
                    text: "立即支付",
                    onPressed: () async {
                      // 支付逻辑
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
