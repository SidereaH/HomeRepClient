import 'package:domrep_flutter/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'category_item.dart';

class QuickRequestItems extends StatelessWidget {
  var categories = [
    "Бытовая техника",
    "Сантехника",
    "Электрика",
    "Газовое оборуд-е",
  ];
  @override
  Widget build(BuildContext context) {
    final HashMap<String, String> categories = HashMap();
    categories["Бытовая техника"] = "Бытовая_техника";
    categories["Сантехника"] = "Сантехника";
    categories["Электрика"] = "Электрика";
    categories["Газовое оборуд-е"] = "Газовое_оборудование";
    return Container(
      decoration: BoxDecoration(
        color: bgcolor,
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          height: 15,
        ),
        Text(
          "Быстрые заявки",
          style: headerComponentStyle,
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: Wrap(
            spacing: 30, // Горизонтальный отступ между элементами
            runSpacing: 21, // Вертикальный отступ между строками
            alignment: WrapAlignment.center, // Выравнивание по центру
            crossAxisAlignment: WrapCrossAlignment
                .center, // Выравнивание по центру по вертикали
            children: categories.entries.map((entry) {
              return CategoryItem(
                imageName: entry.value,
                categoryName: entry.key,
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 33,
        )
      ]),
    );
  }
}
