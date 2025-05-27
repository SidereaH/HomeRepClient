import 'package:domrep_flutter/components/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import '../styles/styles.dart';

class HistoryItem extends StatelessWidget {
  final dynamic order;

  const HistoryItem({super.key, required this.order});

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}.${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  String _getAddress() {
    final address = order['address'];
    if (address == null) return 'Адрес не указан';
    return '${address['streetName']} ${address['buildingNumber']}';
  }

  @override
  Widget build(BuildContext context) {
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
              _formatDate(order['createdAt'] ?? ''),
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
                    'assets/images/what_is_group.png',
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
                          Text("Категория: "),
                          Text(
                            order['category']?['name'] ?? 'Не указана',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Описание: "),
                          Text(
                            order['description'] ?? 'Нет описания',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Статус: "),
                          Text(
                            order['accepted'] == true ? 'Принята' : 'Не принята',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: order['accepted'] == true
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          )
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Text("Адрес: "),
                      //     Text(
                      //       _getAddress(),
                      //       style: TextStyle(fontWeight: FontWeight.w500),
                      //     )
                      //   ],
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Адрес: "),
                          Text(
                            _getAddress(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                        ],
                      ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(order: order),
                  ),
                );
              },

              borderRadius: BorderRadius.circular(5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(5),
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