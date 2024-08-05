import 'package:flutter/material.dart';
import 'package:food/pages/contact_us/leave_message.dart';
import 'package:food/pages/contact_us/list.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/kind_manage/list.dart';
import 'package:food/pages/me/index.dart';
import 'package:food/pages/module/list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: const Color(0xFF232946),
          onBackground: const Color(0xFF333333),
          background: const Color(0xFFF5F5F5),
          onSurface: const Color(0xFF333333),
          surface: const Color(0xFFF5F5F5),
        ),
        useMaterial3: true,
      ),
      routes: {
        '/me': (context) => const Me(),
        '/contactUs': (context) => const ContactUs(),
        '/kindManage': (context) => const KindManage(),
        '/leaveMessage': (context) => const LeaveMessage(),
        '/moduleList': (context) => const ModuleList(),
      },
      home: const MyHomePage(title: 'Food'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}
