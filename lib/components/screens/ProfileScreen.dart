import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:domrep_flutter/config/app_config.dart';

class ProfileScreen extends StatefulWidget {
  final String phoneNumber;

  const ProfileScreen({super.key, required this.phoneNumber});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ClientResponse> _clientFuture;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _clientFuture = _fetchClientData();
  }

  Future<ClientResponse> _fetchClientData() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.MAIN_API_URI}/api/users/phone?phoneNumber=${widget.phoneNumber}'),
        headers: {'Accept': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        return ClientResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Не удалось загрузить данные. Код: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      throw e;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Мой профиль', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<ClientResponse>(
        future: _clientFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildProfileView(snapshot.data!);
          }
          return const Center(child: Text('Данные не найдены'));
        },
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 20),
          Text('Ошибка загрузки', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Попробовать снова'),
            onPressed: () {
              setState(() {
                _clientFuture = _fetchClientData();
                _errorMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView(ClientResponse client) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Аватар с анимацией
          Hero(
            tag: 'user_avatar_${client.id}',
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue[100],
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.blue[800],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Имя пользователя
          Text(
            _getFullName(client),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          // Статус
          Chip(
            label: Text(
              client.status,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: _getStatusColor(client.status),
          ),
          const SizedBox(height: 30),
          // Карточка с информацией
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.phone, 'Телефон', client.phone),
                    const Divider(height: 30),
                    _buildInfoRow(Icons.email, 'Email', client.email),
                    const Divider(height: 30),
                    _buildInfoRow(Icons.credit_card, 'ID', client.id),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFullName(ClientResponse client) {
    return '${client.lastName ?? ''} ${client.firstName} ${client.middleName ?? ''}'.trim();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'premium':
        return Colors.purple;
      case 'vip':
        return Colors.amber[800]!;
      default:
        return Colors.blue;
    }
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактирование профиля'),
        content: const Text('Здесь будет форма редактирования'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}

class ClientResponse {
  final String id;
  final String firstName;
  final String? middleName;
  final String? lastName;
  final String email;
  final String phone;
  final String status;

  ClientResponse({
    required this.id,
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.email,
    required this.phone,
    required this.status,
  });

  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    return ClientResponse(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
    );
  }
}