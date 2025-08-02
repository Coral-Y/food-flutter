import 'package:flutter/material.dart';
import 'package:food/pages/contact_us/leave_message.dart';
import 'package:food/pages/contact_us/list.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/kind_manage/list.dart';
import 'package:food/pages/me/edit_info.dart';
import 'package:food/pages/me/index.dart';
import 'package:food/pages/module/detail.dart';
import 'package:food/pages/module/list.dart';
import 'package:food/pages/recipe/detail.dart';
import 'package:food/pages/recipe/edit.dart';
import 'package:food/pages/recipe/step.dart';
import 'package:food/pages/settings/edit_password.dart';
import 'package:food/pages/settings/index.dart';
import 'package:food/pages/sign_in/index.dart';
import 'package:food/pages/sign_in/privacyPolicy.dart';
import 'package:food/pages/sign_in/register.dart';
import 'package:food/pages/sign_in/set_password.dart';
import 'package:food/pages/sign_in/userAgreement.dart';
import 'package:food/widgets/c_snackbar.dart';
import 'package:food/api/auth.dart';
import 'package:food/api/accounts.dart';
import 'package:provider/provider.dart';
import 'package:food/model/user_info.dart';
import 'package:food/providers/user_provider.dart';
import 'package:food/providers/recipe_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: const Color(0xFF232946),
          onSurface: const Color(0xFF333333),
          surface: const Color(0xFFF5F5F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/setPassword': (context) => const SetPasswordord(),
        '/userAgreement': (context) => const UserAgreement(),
        '/privacyPolicy': (context) => const PrivacyPolicy(),
        '/home': (context) => const Home(),
        '/recipeDetail': (context) => const RecipeDetail(),
        '/editRecipe': (context) => const EditRecipe(),
        '/recipeStep': (context) => const StepPage(),
        '/me': (context) => const Me(),
        '/settings': (context) => const Settings(),
        '/editPassword': (context) => const EditPassword(),
        '/editInfo': (context) => const EditInfo(),
        '/contactUs': (context) => const ContactUs(),
        '/kindManage': (context) => const KindManage(),
        '/leaveMessage': (context) => const LeaveMessage(),
        '/moduleList': (context) => const ModuleList(),
        '/moduleDetail': (context) => const ModuleDetail()
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
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    bool isLoggedIn = await AuthApi().checkLogin();
    if (isLoggedIn) {
      try {
        UserInfo userInfo = await AccountsApi().getUserInfo(); // 这会自动缓存用户信息
        if (!mounted) return;
        context.read<UserProvider>().setUserInfo(userInfo);
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print("Error getting user info: $e");
        CSnackBar(message: '获取用户信息失败').show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}
