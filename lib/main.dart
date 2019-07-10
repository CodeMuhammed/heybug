import 'package:flutter/material.dart';
import 'package:heybug/services/authentication.service.dart';
import './screens/index.dart';

var themeData = new ThemeData(
  primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
  backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
);

// here we have the dashboard app the main app the user navigates to after login
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hey bug',
      theme: themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => UserListScreen(),
      },
    );
  }
}

// here we have the auth app the user navigates to login in
class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hey bug',
      theme: themeData,
      home: LoginScreen(),
    );
  }
}

// here we listen to auth state changes here
class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool _isAuth = false;
  AuthService _authService = new AuthService();

  @override
  void initState() {
    super.initState();

    _authService.authState$().listen((auth) {
      setState(() {
        _isAuth = auth != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isAuth ? Dashboard() : AuthApp();
  }
}

// This runs the main application
void main() => runApp(MyApp());
