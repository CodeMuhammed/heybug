import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  final Widget bodyContent;
  final String title;
  final List<Widget> actions;

  AppShell({
    @required this.bodyContent,
    @required this.title,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        actions: actions,
      ),
      body: bodyContent,
    );
  }
}
