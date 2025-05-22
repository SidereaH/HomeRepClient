import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class OrderDetailsScreen extends StatelessWidget {
  final dynamic order;

  const OrderDetailsScreen({super.key, required this.order});

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}.0${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  String _getAddress() {
    final address = order['address'];
    if (address == null) return 'Адрес не указан';
    return '${address['streetName']} ${address['buildingNumber']}';
  }

  Widget buildSection(String title, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: headerComponentStyle),
        SizedBox(height: 4),
        Text(
          value,
          style: categoryNameTextStyle.copyWith(
            color: valueColor ?? textColor,
          ),
        ),
        Divider(height: 24, thickness: 1, color: secondaryBg),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenColor,
      appBar: AppBar(
        title: Text("Детали заказа", style: TextStyle(color: whiteColor)),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Информация о заказе", style: titleStyle),
              SizedBox(height: 16),

              buildSection("Дата создания", _formatDate(order['createdAt'] ?? '')),
              buildSection("Категория", order['category']?['name'] ?? 'Не указана'),
              buildSection("Описание", order['description'] ?? 'Нет описания'),
              buildSection(
                "Статус",
                order['accepted'] == true ? 'Принята' : 'Не принята',
                valueColor: order['accepted'] == true ? Colors.green : Colors.red,
              ),
              buildSection("Адрес", _getAddress()),

              if (order['image'] != null) ...[
                Text("Изображение", style: headerComponentStyle),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    order['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],

              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Вернуться", style: buttonTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
