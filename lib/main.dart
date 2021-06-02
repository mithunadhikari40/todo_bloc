import 'package:flutter/material.dart';
import 'package:todo/src/blocs/auth_bloc_provider.dart';
import 'package:todo/src/blocs/todo_bloc_provider.dart';
import 'package:todo/src/screens/login_screen.dart';
import 'package:todo/src/screens/todo_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      theme: ThemeData.light(),
      home: AuthBlocProvider(
        child: LoginScreen(),
      ),
    );
  }
}
