import 'package:flutter/material.dart';

class ImageHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'imageHero',
      child: Image.network(
        'https://images.unsplash.com/photo-1523453417477-08798d566329?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main screen'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailScreen();
          }));
        },
        child: Container(
          child: ImageHero(),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: ImageHero(),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Hero Navigation',
      home: MainScreen(),
    );
  }
}

// This runs the main application
void main() => (runApp(MyApp()));
