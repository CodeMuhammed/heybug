import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home screen')),
      body: Center(
        child: SelectionButton(),
      ),
    );
  }
}

class SelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Pick an option, any option!'),
      onPressed: () => _navigateToSelectionScreen(context),
    );
  }

  _navigateToSelectionScreen(BuildContext context) async {
    final result = await Navigator.pushNamed(context, SelectionScreen.route);

    // here we need to clear the provious toast and display another one
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(result)));
  }
}

class SelectionScreen extends StatelessWidget {
  static const route = '/selection_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selection Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('Yes!'),
                onPressed: () {
                  Navigator.pop(context, 'Yes!');
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('No!'),
                onPressed: () {
                  Navigator.pop(context, 'No!');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popup routes example',
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (context) => HomeScreen(),
        SelectionScreen.route: (context) => SelectionScreen(),
      },
    );
  }
}

// This runs the main application
void main() => (runApp(MyApp()));
