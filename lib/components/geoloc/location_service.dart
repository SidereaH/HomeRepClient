import 'dart:convert';
import 'package:domrep_flutter/config/app_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class LocationService {
  static Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return null;
    }
  }

  static Future<String> getAddressByCoordinates(
      double latitude, double longitude) async {
    final apiKey = AppConfig.YANDEX_GEOCODER;
    final url =
        'https://geocode-maps.yandex.ru/1.x/?apikey=$apiKey&geocode=$longitude,$latitude&format=json&results=1';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results =
        data['response']['GeoObjectCollection']['featureMember'];
        if (results is List && results.isNotEmpty) {
          return results[0]['GeoObject']['name'] ?? "Неизвестный адрес";
        }
      }
    } catch (e) {
      return "Ошибка запроса: $e";
    }

    return "Не удалось определить адрес";
  }

  static Future<String> getCurrentAddress() async {
    final hasPermission = await checkAndRequestPermission();
    if (!hasPermission) {
      return "Разрешение на геолокацию отклонено";
    }

    final position = await getCurrentPosition();
    if (position == null) {
      return "Не удалось получить позицию";
    }

    return await getAddressByCoordinates(position.latitude, position.longitude);
  }
}
