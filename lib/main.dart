import 'package:flutter/material.dart';
import './components/app_header.dart'; // Импортируем компонент

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'GolosText',),
      home: Scaffold(
        appBar: AppHeader(), // Используем компонент
        body: Center(child: Text("Контент здесь")),
      ),
    );
  }
}
