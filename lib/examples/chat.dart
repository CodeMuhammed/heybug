import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData defaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

void main() {
  runApp(FriendlyChatApp());
}

class FriendlyChatApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(
        title: 'Friendly chat',
        home: ChatScreen(),
        theme: Platform.isIOS ? kIOSTheme : defaultTheme);
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreenState createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _messages = <ChatMessage>[];
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friendly chat'),
        elevation: Platform.isIOS ? 0.0 : 4.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (context, i) => _messages[i],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            _buildTextComposer()
          ],
        ),
        decoration: Platform.isIOS ? BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[200])
          )
        ) : null,
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 30),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) => {
                      setState(() {
                        _isComposing = text.length > 0;
                      })
                    },
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            Container(
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Send'),
                      onPressed: _isComposing
                          ? () => _handleSubmit(_textController.text)
                          : null)
                  : IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmit(_textController.text)
                          : null),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String text) {
    _textController.clear();

    if (text.length > 0) {
      final messageAnimation = new AnimationController(
          duration: Duration(milliseconds: 300), vsync: this);
      ChatMessage message =
          new ChatMessage(text: text, animationController: messageAnimation);

      setState(() {
        _isComposing = false;
        _messages.insert(0, message);
        message.animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final AnimationController animationController;
  final String _name = 'Muhammed Ali';

  ChatMessage({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: _getChatItem(context),
    );
  }

  Widget _getChatItem(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child:
                        Text(_name, style: Theme.of(context).textTheme.subhead),
                  ),
                  Container(
                    child: Text(text),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
