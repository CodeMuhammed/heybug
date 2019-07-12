import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/index.dart';

class BugReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Bug Reports',
      bodyContent: Center(
        child: Text('Bug report screen'),
      ),
    );
  }
}
