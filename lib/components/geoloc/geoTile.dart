import 'dart:convert';

import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String geocode_api = AppConfig.YANDEX_GEOCODER;
  String _locationMessage = "Мечникова 77А";
  double? _latitude;
  double? _longitude;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Службы геолокации отключены.";
      });
      return;
    }

    // Проверяем разрешения на доступ к геолокации
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Разрешения не предоставлены, показываем сообщение пользователю
        setState(() {
          _locationMessage = "Разрешения на доступ к геолокации не предоставлены.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Разрешения навсегда отклонены, показываем сообщение пользователю
      setState(() {
        _locationMessage = "Разрешения на доступ к геолокации навсегда отклонены.";
      });
      return;
    }

    // Получаем текущее местоположение
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Получаем адрес по координатам
    String address = await _getAddressByGeo(position.latitude, position.longitude);

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _locationMessage = address;
    });
  }

  Future<String> _getAddressByGeo(double latitude, double longitude) async {
    final url =
        'https://geocode-maps.yandex.ru/1.x/?apikey=$geocode_api&geocode=$longitude,$latitude&format=json&results=1';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['response']['GeoObjectCollection']['featureMember'];
        if (results is List && results.isNotEmpty) {
          final address = results[0]['GeoObject']['name'] ?? 'Неизвестный адрес';
          return address;
        }
      }
    } catch (e) {
      return 'Ошибка при получении местоположения: $e';
    }
    return "Ошибка при получении местоположения";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Моё местоположение'),
      subtitle: Text(_locationMessage),
      leading: Icon(Icons.location_on),
      onTap: _getCurrentLocation,
    );
  }
}