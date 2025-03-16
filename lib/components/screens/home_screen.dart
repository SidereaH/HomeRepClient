import 'package:domrep_flutter/components/question_button.dart';
import 'package:domrep_flutter/components/quick_request.dart';
import 'package:flutter/material.dart';

import '../app_header.dart';
import '../history_list.dart';
import '../menu_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(bonuses: 1000, address: "Гагарина 1"),
      drawer: Drawer(
        child: MenuItems()
      ),
      body: Center(
        child: Column(children: [
          QuickRequests(),
          SizedBox(height: 15,),
          QuestionButton(
            colorAccent: Color(0xffFF8200),
            question: "Что-то сломалось?",
          ),
          Text("Здесь вы можете заполнить заявку"),
          SizedBox(height: 10,),
          HistoryList(),
          // CategoryItem(imagePath: "assets/images/categories/household_appliances_category.png", categoryName: "Бытовая техника",)
        ]),
      ),
    );
  }
}
