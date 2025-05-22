import 'package:domrep_flutter/components/geoloc/user_service.dart';
import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import '../../components/geoloc/user_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final dynamic order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  User? _user;
  bool _loadingUser = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();

  }

  Future<void> _fetchUser() async {
    if (widget.order["employeeId"] != null) {
      setState(() => _loadingUser = true);
      try {
        final user = await UserService.getUserById(widget.order["employeeId"]);
        setState(() {
          _user = user;
          _loadingUser = false;
        });
      } catch (_) {
        setState(() {
          _user = User("Ошибка", "загрузки", "-", "-");
          _loadingUser = false;
        });
      }
    }
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}.${dateTime.month.toString().padLeft(2, '0')} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  String _getAddress() {
    final address = widget.order['address'];
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
          style: categoryNameTextStyle.copyWith(color: valueColor ?? textColor),
        ),
        Divider(height: 24, thickness: 1, color: secondaryBg),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

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
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
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
                SizedBox(height: 16),
              ],
              SizedBox(height: 8),
              Divider(height: 32, thickness: 2, color: primaryColor.withOpacity(0.3)),

              Text("Исполнитель", style: bonusTextStyle),
              SizedBox(height: 12),
              if (_loadingUser)
                Center(child: CircularProgressIndicator(color: primaryColor))
              else if (_user != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSection("Имя", "${_user!.firstName} ${_user!.lastName}"),
                    buildSection("Почта", _user!.email),
                    buildSection("Телефон", _user!.phone),
                  ],
                )
              else
                Text("Информация об исполнителе недоступна.", style: tipText),

              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
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
