import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _locationMessage = "Мечникова 77А";
  double? _latitude;
  double? _longitude;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Проверяем, включены ли службы геолокации
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Службы геолокации отключены, показываем сообщение пользователю
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
          _locationMessage =
              "Разрешения на доступ к геолокации не предоставлены.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Разрешения навсегда отклонены, показываем сообщение пользователю
      setState(() {
        _locationMessage =
            "Разрешения на доступ к геолокации навсегда отклонены.";
      });
      return;
    }

    // Получаем текущее местоположение
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;

      _locationMessage = "Широта: $_latitude, Долгота: $_longitude";
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Моё местоположение'),
      subtitle: Text(_locationMessage),
      leading: Icon(Icons.location_on),
    );
  }
}
