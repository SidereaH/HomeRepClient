import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        Uri.parse(AppConfig.MAIN_API_URI+'/api/users/phone?phoneNumber=${widget.phoneNumber}'),
      );

      if (response.statusCode == 200) {
        return ClientResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load client data');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      throw e;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: FutureBuilder<ClientResponse>(
        future: _clientFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final client = snapshot.data!;
            return _buildProfileView(client);
          } else {
            return const Center(child: Text('Нет данных'));
          }
        },
      ),
    );
  }

  Widget _buildProfileView(ClientResponse client) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileItem('Имя', client.firstName),
          if (client.middleName != null) _buildProfileItem('Отчество', client.middleName!),
          if (client.lastName != null) _buildProfileItem('Фамилия', client.lastName!),
          _buildProfileItem('Email', client.email),
          _buildProfileItem('Телефон', client.phone),
          _buildProfileItem('Статус', client.status.toString()),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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