import 'package:flutter/material.dart';
import 'package:heybug/services/authentication.service.dart';
import './screens/index.dart';
import './app-theme.dart';

// make the auth app a statful widget so that 
// here we have the auth app the user navigates to login in
class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hey bug',
      theme: AppThemeData.theme,
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
