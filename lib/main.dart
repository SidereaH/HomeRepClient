import 'package:domrep_flutter/components/history_list.dart';
import 'package:domrep_flutter/components/screens/sign_in_screen.dart';
import 'package:domrep_flutter/components/screens/sign_up_screen.dart';

import 'package:flutter/material.dart';
import './components/app_header.dart';

import 'components/screens/home_screen.dart';
import 'components/quick_request.dart'; // Импортируем компонент
import 'components/question_button.dart';
import 'config/app_config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig().load();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'GolosText',
      ),
      // home: HomeScreen(),
      home: SignUpScreen(),
      // home: Scaffold(
      //     appBar: AppHeader(
      //         bonuses: 1000, address: "Гагарина 1"), // Используем компонент
      //     body: Column(children: [
      //       //       QuickRequests(),
      //       //       SizedBox(height: 15,),
      //       //       QuestionButton(
      //       //         colorAccent: Color(0xffFF8200),
      //       //         question: "Что-то сломалось?",
      //       //       ),
      //       //       Text("Здесь вы можете заполнить заявку"),
      //       //       SizedBox(height: 10,),
      //       //       HistoryList()
      //       //     ])
      //           //CategoryItem(imagePath: "assets/images/categories/household_appliances_category.png", categoryName: "Бытовая техника",),
      //  ),
    );
  }
}
