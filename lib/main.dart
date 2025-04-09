import 'package:domrep_flutter/components/history_list.dart';
import 'package:domrep_flutter/components/screens/sign_in_screen.dart';
import 'package:domrep_flutter/components/screens/sign_up_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/app_header.dart';

import 'components/screens/home_screen.dart';
import 'components/quick_request.dart'; // Импортируем компонент
import 'components/question_button.dart';
import 'config/app_config.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig().load();

  // Получаем экземпляр SharedPreferences
  final storage = await SharedPreferences.getInstance();

  // Проверяем наличие токенов
  final accessToken = storage.getString('accessToken');
  final refreshToken = storage.getString('refreshToken');
  final initialRoute = (accessToken == null || refreshToken == null) ? '/' : '/home';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'GolosText',
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const SignInScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }
}