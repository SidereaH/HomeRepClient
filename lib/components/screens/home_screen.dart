import 'package:domrep_flutter/components/geoloc/location_service.dart';
import 'package:domrep_flutter/components/question_button.dart';
import 'package:domrep_flutter/components/quick_request.dart';
import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';

import '../app_header.dart';
import '../history_list.dart';
import '../menu_items.dart';
import 'dart:convert';
import 'package:domrep_flutter/components/question_button.dart';
import 'package:domrep_flutter/components/quick_request.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../app_header.dart';
import '../history_list.dart';
import '../menu_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _address = "Получение адреса...";

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final address = await LocationService.getCurrentAddress();
    setState(() {
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(bonuses: 1000, address: _address),
      drawer: Drawer(child: MenuItems()),
      body: Center(
        child: Column(
          children: [
            QuickRequests(),
            const SizedBox(height: 15),
            QuestionButton(
              colorAccent: const Color(0xffFF8200),
              question: "Что-то сломалось?",
            ),
            const Text("Здесь вы можете заполнить заявку"),
            const SizedBox(height: 10),
            HistoryList(),
          ],
        ),
      ),
    );
  }
}