import 'dart:convert';

import 'package:domrep_flutter/components/geoloc/geoTile.dart';
import 'package:domrep_flutter/components/geoloc/location_service.dart';
import 'package:domrep_flutter/components/screens/ProfileScreen.dart';
import 'package:domrep_flutter/components/screens/about_screen.dart';
import 'package:domrep_flutter/components/screens/discounts_screen.dart';
import 'package:domrep_flutter/components/screens/history_screen.dart';
import 'package:domrep_flutter/components/screens/partner_screen.dart';
import 'package:domrep_flutter/components/screens/security_screen.dart';
import 'package:domrep_flutter/components/screens/settings_screen.dart';
import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MenuItems extends StatefulWidget {
  const MenuItems({super.key});

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  String _address = "Получение адреса...";

  Future<String> _getUserId() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    final phoneNumber = storage.getString('phoneNumber') ?? '79882578790';
    final response = await http.get(
      Uri.parse('${AppConfig.MAIN_API_URI}/api/users/phone?phoneNumber=$phoneNumber'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    final decodedBody = utf8.decode(response.bodyBytes);
    print(decodedBody);

    if (response.statusCode == 200) {
      return "${ClientResponse.fromJson(jsonDecode(decodedBody)).firstName} ${ClientResponse.fromJson(jsonDecode(decodedBody)).lastName}";
    } else {
      throw Exception('Не удалось загрузить данные. Код: ${response.statusCode}');
    }
  }

  Future<void> _navigateToProfile() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    final phoneNumber = storage.getString('phoneNumber') ?? '79882578790';
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(phoneNumber: phoneNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserId(),
      builder: (context, snapshot) {
        final name = snapshot.hasData ? snapshot.data! : 'Загрузка...';

        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text('★ 2.99'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              onDetailsPressed: _navigateToProfile,
            ),
            LocationScreen(),
            ListTile(
              title: Text('История заказов'),
              leading: Icon(Icons.history),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Способы оплаты'),
              leading: Icon(Icons.payment),
              trailing: Chip(
                label: Text('МИР'),
                backgroundColor: Colors.green.shade100,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text('Стать партнером DomRep'),
              leading: Icon(Icons.business),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PartnerScreen()));
              },
            ),
            ListTile(
              title: Text('Безопасность'),
              leading: Icon(Icons.security),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityScreen()));
              },
            ),
            ListTile(
              title: Text('Скидки'),
              leading: Icon(Icons.discount),
              subtitle: Text('Введите промокод'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DiscountsScreen()));
              },
            ),
            ListTile(
              title: Text('Настройки'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              },
            ),
            ListTile(
              title: Text('Информация'),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
              },
            ),
            ListTile(
              title: Text('Выйти'),
              leading: Icon(Icons.logout),
              onTap: () async {
                final SharedPreferences storage = await SharedPreferences.getInstance();
                storage.clear();
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ],
        );
      },
    );
  }
}

class ClientResponse {
  final String firstName;
  final String lastName;

  ClientResponse({required this.firstName, required this.lastName});

  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    return ClientResponse(
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}