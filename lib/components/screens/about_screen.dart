import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: FlutterLogo(size: 100),
            ),
            const SizedBox(height: 20),
            const Text(
              'DomRep - сервис домашнего ремонта',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Версия 1.0.0'),
            const Divider(height: 30),
            _buildInfoTile('Разработчик', Icons.language, () {
              _launchUrl('https://t.me/SidereaH');
            }),
            _buildInfoTile('Пользовательское соглашение', Icons.description, () {
              // Навигация к соглашению
            }),
            _buildInfoTile('Обратная связь', Icons.email, () {
              _launchUrl('mailto:homerep_systems@mail.ru');
            }),
            const Spacer(),
            const Center(
              child: Text('© 2023 DomRep. Все права защищены'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}