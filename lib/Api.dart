import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String _baseUrl = "http://192.168.100.10:8080/api";

  static Future<String> login(String email, String password) async {
    var response = await http.post(
      Uri.parse("$_baseUrl/ukm/auth"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Login gagal");
    }
  }
}
