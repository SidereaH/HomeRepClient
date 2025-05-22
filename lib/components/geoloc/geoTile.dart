import 'dart:convert';

import 'package:domrep_flutter/components/geoloc/location_service.dart';
import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _address = "Поиск местоположения...";
  Future<void> _loadAddress() async {
    final address = await LocationService.getCurrentAddress();
    setState(() {
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadAddress();
    return ListTile(
      title: Text('Моё местоположение'),
      subtitle: Text(_address),
      leading: Icon(Icons.location_on),
    );
  }
}