import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Безопасность'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSecurityItem(
            icon: Icons.lock,
            title: 'Безопасность аккаунта',
            subtitle: 'Настройки входа и пароль',
          ),
          _buildSecurityItem(
            icon: Icons.credit_card,
            title: 'Платежные данные',
            subtitle: 'Управление способами оплаты',
          ),
          _buildSecurityItem(
            icon: Icons.notifications,
            title: 'Уведомления',
            subtitle: 'Настройки оповещений',
          ),
          _buildSecurityItem(
            icon: Icons.privacy_tip,
            title: 'Конфиденциальность',
            subtitle: 'Настройки приватности',
          ),
          const SizedBox(height: 20),
          const Text(
            'Последняя активность',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          _buildActivityItem('Вход с нового устройства', 'Сегодня, 14:30'),
          _buildActivityItem('Изменен пароль', 'Вчера, 10:15'),
        ],
      ),
    );
  }

  Widget _buildSecurityItem({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Навигация к детальным настройкам
      },
    );
  }

  Widget _buildActivityItem(String action, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.circle, size: 10, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(child: Text(action)),
            Text(time, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}