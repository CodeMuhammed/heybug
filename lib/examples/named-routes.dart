import 'package:flutter/material.dart';

class ScreenArguments {
  final String title;

  ScreenArguments({this.title});
}

class FirstRoute extends StatelessWidget {
  static const id = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Center(
        child: FlatButton(
          child: Text('Goto second'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              SecondRoute.id,
              arguments: ScreenArguments(title: 'Second page title'),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  static const id = '/second';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments arguments = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments.title),
      ),
      body: Center(
        child: FlatButton(
          child: Text('Goto first'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

// this is the main app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test app',
      initialRoute: '/',
      routes: {
        FirstRoute.id: (context) => FirstRoute(),   // :/
        SecondRoute.id: (context) => SecondRoute(), // :/second
      },
    );
  }
}

// This runs the main application
void main() => (runApp(MyApp()));
