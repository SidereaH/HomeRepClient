import 'package:domrep_flutter/components/geoloc/geoTile.dart';
import 'package:domrep_flutter/components/screens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuItems extends StatelessWidget {
  const MenuItems({super.key});

  Future<void> _navigateToProfile(BuildContext context) async {
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
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text('Александр Рубенштейн'),
          accountEmail: Text('★ 2.99'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          onDetailsPressed: () {
            // Здесь должен быть реальный номер из вашего хранилища
            _navigateToProfile(context);
          },
        ),
        LocationScreen(),
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
        ListTile(
          title: Text('Выйти'),
          leading: Icon(Icons.logout),
          onTap: () async {
            final SharedPreferences storage =
                await SharedPreferences.getInstance();
            // Сохраняем токены (например, в SharedPreferences)
            storage.clear();
            Navigator.pushReplacementNamed(context, '/signin');
          },
        ),
      ],
    );
  }
}
