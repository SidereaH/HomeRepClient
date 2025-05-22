import 'package:domrep_flutter/components/history_item.dart';
import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/cupertino.dart';

import '../styles/styles.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }
  Future<void> _fetchOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final clientId = prefs.getString('id');

      if (clientId == null) {
        throw Exception('Client ID not found');
      }

      final response = await http.get(
        Uri.parse('${AppConfig.MAIN_API_URI}/api/orders/user/$clientId'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Декодируем тело ответа с учетом кодировки UTF-8
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);

        setState(() {
          orders = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading orders: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: bgcolor,
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 10,
              offset: Offset(0, -4),
              spreadRadius: -6,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 15),
            Text("История заявок", style: headerComponentStyle),
            SizedBox(height: 23),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(child: Text(errorMessage))
            else if (orders.isEmpty)
                Center(child: Text('Нет заявок'))
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 20),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: HistoryItem(order: orders[index]),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}