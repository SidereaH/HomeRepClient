import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'Русский';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Уведомления'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Темная тема'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          ListTile(
            title: const Text('Язык'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(),
          ),
          const Divider(),
          ListTile(
            title: const Text('Очистить кеш'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Логика очистки кеша
            },
          ),
          ListTile(
            title: const Text('Политика конфиденциальности'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Навигация к политике
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите язык'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('Русский'),
              _buildLanguageOption('English'),
              _buildLanguageOption('Español'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: _language == language ? const Icon(Icons.check) : null,
      onTap: () {
        setState(() {
          _language = language;
        });
        Navigator.pop(context);
      },
    );
  }
}