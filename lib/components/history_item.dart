import 'package:flutter/material.dart';

import '../models/history_item.dart';
import '../styles/styles.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    HistoryItemModel item = HistoryItemModel(
      "10.02 14:00",
      "Сантехника",
      "Кран потек",
      "Чупапи Чупа Чупачиви",
      "Смычки 72",
      1800,
    );
    // TODO: implement build
    return Container(
      width: 350,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.date,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/what_is_group.png', // Замените на ссылку на изображение
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Кат-я: ",
                            ),
                          Text(item.category,style: TextStyle(fontWeight: FontWeight.w500) )
                      ]),
                      Row(
                          children: [
                            Text("Крат. описание: ",
                            ),
                            Text(item.shortDesc,style: TextStyle(fontWeight: FontWeight.w500) )
                          ]),
                      Row(
                          children: [
                            Text("Мастер: ",
                            ),
                            Text(item.masterName,style: TextStyle(fontWeight: FontWeight.w500) )
                          ]),
                      Row(
                          children: [
                            Text("Адрес: ",
                            ),
                            Text(item.address, style: TextStyle(fontWeight: FontWeight.w500) )
                          ]),
                      Row(
                          children: [
                            Text("Итого:  ",
                            ),
                            Text(item.getItemCosts(), style: TextStyle(fontWeight: FontWeight.w500) )
                          ]),


                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                // Действие при нажатии
              },
              borderRadius: BorderRadius.circular(5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor, // Оранжевый цвет фона
                  borderRadius: BorderRadius.circular(5), // Закругленные края
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Подробнее",
                      style: buttonText,

                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      "assets/images/blue_arrow_button.png",
                      width: 15,
                    ),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
