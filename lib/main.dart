import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/src/blocs/auth_bloc_provider.dart';
import 'package:todo/src/blocs/cache_bloc.dart';
import 'package:todo/src/screens/login_screen.dart';
import 'package:todo/src/screens/todo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await cache.setup();
  bool isLoggedIn = cache.currentUid != null;

  runApp(App(isLoggedIn));
}

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App(this.isLoggedIn);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      theme: ThemeData.light(),
      home: isLoggedIn
          ? TodoScreen()
          : AuthBlocProvider(
              child: LoginScreen(),
            ),
    );
  }
}
