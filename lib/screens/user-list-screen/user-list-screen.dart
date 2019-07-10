import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/index.dart';
import '../../services/index.dart';
import '../../models/index.dart';

class UserListScreen extends StatefulWidget {
  @override
  UserListScreenState createState() {
    return UserListScreenState();
  }
}

class UserListScreenState extends State<UserListScreen> {
  List<User> _users;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Users List',
      bodyContent: Center(
        child: Text('Users list heres'),
      ),
    );
  }
}
