import 'dart:convert';
import 'dart:ffi';

import 'package:domrep_flutter/config/app_config.dart';
import 'package:http/http.dart' as http;

class UserService{
  static Future<User> getUserById(int id) async {
    final url = "${AppConfig.MAIN_API_URI}/api/users/$id";
    try {
      final response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json; charset=utf-8'},);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final decodedBody = utf8.decode(response.bodyBytes);
        final decoded = jsonDecode(decodedBody);
        return new User(decoded["firstName"], decoded["lastName"], data["email"], data["phone"]);
      }
    } catch (e) {
      return new User("error", "error", "error", "error");
    }
    return new User("firstName", "lastName", "email", "phone");
  }


}
class User{
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  User(this.firstName, this.lastName, this.email, this.phone);
}
