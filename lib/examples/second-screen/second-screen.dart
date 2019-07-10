import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/index.dart';

class SecondScreen extends StatelessWidget {
  @override
  build(BuildContext context) {
    return AppShell(
      title: 'second Screen',
      bodyContent: Center(
        child: RaisedButton(
          child: Text('second screen'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
