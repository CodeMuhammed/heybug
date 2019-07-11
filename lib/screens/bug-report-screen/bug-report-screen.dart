import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/index.dart';
import '../../services/index.dart';
import '../../models/index.dart';

class BugReportScreen extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Bug Reports',
      bodyContent: Center(
        child: Text('Bug report screen'),
      ),
      showDrawer: false,
    );
  }
}
