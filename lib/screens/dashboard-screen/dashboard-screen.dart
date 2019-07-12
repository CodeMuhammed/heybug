// here we have the dashboard app the main app the user navigates to after login
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:heybug/app-theme.dart';
import 'package:heybug/models/User.dart';
import 'package:heybug/screens/index.dart';
import 'package:heybug/services/authentication.service.dart';
import 'package:heybug/services/user.service.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() {
    return new DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  final FirebaseMessaging _fcm = new FirebaseMessaging();
  final UserService _userService = new UserService();
  final AuthService _authService = new AuthService();
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }

    // here we configure the fcm to listen to messages
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: ListTile(
                title: Text(message['title']),
                subtitle: Text(message['body']),
                leading: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(message['icon']),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      /*onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // @TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // @TODO optional
      },*/
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hey bug',
      theme: AppThemeData.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => UserListScreen(),
        '/bug-report': (context) => BugReportScreen(),
      },
    );
  }

  @override
  void dispose() {
    if (iosSubscription != null) iosSubscription.cancel();
    super.dispose();
  }

  _saveDeviceToken() async {
    FirebaseUser authUser = await _authService.getCurrentUser();

    if (authUser != null) {
      User user = await _userService.getUserByEmail(authUser.email);

      // we get the token for this device
      String fcmToken = await _fcm.getToken();

      if (fcmToken != null) {
        user.fcmToken = fcmToken;
        user.fcmPlatform = Platform.operatingSystem;
      }

      // here we update the user to the db
      _userService.updateUser(user);
    }
  }
}
