import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo/src/model/user_model.dart';

class AuthApi {
  Future<UserModel?> login(String email, String password) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };
    try {
      var uri = Uri.parse("https://api.fresco-meat.com/api/albums/signup");
      final response = await post(
        uri,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );
      final body = response.body;
      print("Signup response $body");
      if (response.statusCode != 201) return null;
      final parsedMap = jsonDecode(body);
      final user = UserModel.fromJson(parsedMap);
      return user;
    } catch (e) {
      print("Sigup exception $e");
      return null;
    }
  }
}
