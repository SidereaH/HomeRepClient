import 'package:flutter/material.dart';
import './components/app_header.dart';
import 'components/category_item.dart';
import 'components/quick_request.dart'; // Импортируем компонент

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'GolosText',
      ),
      home: Scaffold(
          appBar: AppHeader(
              bonuses: 1000, address: "Гагарина 1"), // Используем компонент
          body: Container(
            child: QuickRequests(),
          )
          //CategoryItem(imagePath: "assets/images/categories/household_appliances_category.png", categoryName: "Бытовая техника",),
          ),
    );
  }
}
