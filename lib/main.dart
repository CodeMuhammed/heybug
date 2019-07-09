import 'package:flutter/material.dart';
import './screens/index.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hey bug',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
      },
    );
  }
}

// This runs the main application
void main() => (runApp(MyApp()));
