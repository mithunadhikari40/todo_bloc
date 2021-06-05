import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo/src/model/todo_model.dart';

class TodoApi {
  var root = "https://todo-e3cde-default-rtdb.firebaseio.com/todo.json";

  Future<List<TodoModel>?> getAllTodos() async {
    try {
      final uri = Uri.parse(root);
      final response = await get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      print("The response is $body");

      List<TodoModel> todos = [];
      for (var key in body.keys) {
        final singleTodo = TodoModel.fromJson(body[key], key);
        todos.add(singleTodo);
      }
      return todos;
    } catch (e) {
      print("Error are $e");
      return null;
    }
  }

  Future<bool> createTodo(TodoModel todo) async {
    try {
      final uri = Uri.parse(root);
      final response = await post(uri, body: jsonEncode(todo.toJson()));
      if (response.statusCode != 200) {
        return false;
      }
      var body = jsonDecode(response.body);
      print("Body $body");
      if (body["name"] == null) {
        return false;
      }
      return true;
    } catch (e) {
      print("Creating todo error $e");
      return false;
    }
  }

  Future<bool> updateTodo(TodoModel todo) async {
    var url = "https://todo-e3cde-default-rtdb.firebaseio.com/todo";
    try {
      final uri = Uri.parse("$url/${todo.id}.json");
      print("Uri is $uri");
      final response = await put(uri, body: jsonEncode(todo.toJson()));
      if (response.statusCode != 200) {
        return false;
      }
      var body = jsonDecode(response.body);
      print("Body $body");
      if (body["name"] == null) {
        return false;
      }
      return true;
    } catch (e) {
      print("Updating todo error $e");
      return false;
    }
  }

  Future<bool> deleteTodo(String id) async {
    var url = "https://todo-e3cde-default-rtdb.firebaseio.com/todo";
    try {
      final uri = Uri.parse("$url/$id.json");
      print("Uri is $uri");
      final response = await delete(uri);
      if (response.statusCode != 200) {
        return false;
      }
      var body = jsonDecode(response.body);
      print("Body $body");
      return true;
    } catch (e) {
      print("Delete todo error $e");
      return false;
    }
  }
}
