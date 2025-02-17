import 'package:domrep_flutter/styles/styles.dart';
import 'package:flutter/cupertino.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: bgcolor,
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
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
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 159, // Укажите максимальную высоту, если нужно
          ),
          child: Center(
            child: Wrap(
              spacing: 30, // Горизонтальный отступ между элементами
              runSpacing: 21, // Вертикальный отступ между строками
              alignment: WrapAlignment.center, // Выравнивание по центру
              crossAxisAlignment: WrapCrossAlignment
                  .center, // Выравнивание по центру по вертикали
              children: categories.map((category) {
                return CategoryItem(
                  imagePath:
                      'assets/images/categories/household_appliances_category.png', // Путь к изображению
                  categoryName: category,
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 33,
        )
      ]),
    );
  }
}
