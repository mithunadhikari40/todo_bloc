import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:todo/src/model/user_model.dart';

class AuthApi {
  Future<UserModel?> login(String email, String password) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "gender": "none"
    };
    try {
      var uri = Uri.parse("https://api.fresco-meat.com/api/albums/signup");
      final response = await post(
        uri,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );
      final body = response.body;
      print("login response $body");
      if (response.statusCode != 201) return null;
      final parsedMap = jsonDecode(body);
      final user = UserModel.fromJson(parsedMap);
      return user;
    } catch (e) {
      print("login exception $e");
      return null;
    }
  }

  Future<bool?> loginWithFirebase(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null) return false;
      final uid = user.uid;
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<UserModel?> register(
      String name, String phone, String email, String password) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
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

  Future<bool?> registerWithFirebase(
      String name, String phone, String email, String password) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
    };

    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null) return false;
      final uid = user.uid;
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
