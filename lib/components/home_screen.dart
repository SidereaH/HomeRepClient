import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_header.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
                bonuses: 1000, address: "Гагарина 1"),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Александр Рубенштейн'),
              accountEmail: Text('★ 2.99'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            ListTile(
              title: Text('Моё местоположение'),
              subtitle: Text('Мечникова 77А'),
              leading: Icon(Icons.location_on),
            ),
            ListTile(
              title: Text('История заказов'),
              leading: Icon(Icons.history),
              onTap: () {},
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
              onTap: () {},
            ),
            ListTile(
              title: Text('Служба поддержки'),
              leading: Icon(Icons.support),
              onTap: () {},
            ),
            ListTile(
              title: Text('Безопасность'),
              leading: Icon(Icons.security),
              onTap: () {},
            ),
            ListTile(
              title: Text('Мои адреса'),
              leading: Icon(Icons.location_city),
              onTap: () {},
            ),
            ListTile(
              title: Text('Скидки'),
              leading: Icon(Icons.discount),
              subtitle: Text('Введите промокод'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Настройки'),
              leading: Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: Text('Информация'),
              leading: Icon(Icons.info),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Главный экран'),
      ),
    );
  }
}
