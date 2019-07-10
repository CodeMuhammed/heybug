import 'package:flutter/material.dart';
import './screens/index.dart';

// here we listen to auth state changes here
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hey bug',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/user-list': (context) => UserListScreen(),
      },
    );
  }
}

// This runs the main application
void main() => runApp(MyApp());
