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
      for (var item in body.values) {
        final singleTodo = TodoModel.fromJson(item);
        todos.add(singleTodo);
      }
      return todos;
    } catch (e) {
      print("Error are $e");
      return null;
    }
  }
}
